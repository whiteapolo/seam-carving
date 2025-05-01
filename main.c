#include <SDL2/SDL_keycode.h>
#include <SDL2/SDL_surface.h>
#include <endian.h>
#include <math.h>
#include <stdio.h>
#include <stdbool.h>
#include <SDL2/SDL_events.h>
#include <SDL2/SDL_pixels.h>
#include <SDL2/SDL_rect.h>
#include <SDL2/SDL_render.h>
#include <SDL2/SDL_stdinc.h>
#include <SDL2/SDL_timer.h>
#include <SDL2/SDL_video.h>
#include <SDL2/SDL_image.h>
#include <SDL2/SDL.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <unistd.h>
#include <pthread.h>
#include <stdint.h>
#include <limits.h>
#include <wchar.h>
#include <wh/messure_time.h> // TODO: remove
#include "util.h"


const char RED[] = { 0xff, 0, 0 };

#define WINDOW_WIDTH 800
#define WINDOW_HEIGHT 800

#define IMG_SCALE 1

typedef struct __attribute__((packed)) {
	unsigned char r, g, b; // must be first
	unsigned int x, y;
	int gradient;
	int gradient_sum;
} Pixel;

typedef struct {
	Pixel **pixels;
	int w;
	int h;
} Image;

typedef struct {
	unsigned int relative_x;
	unsigned int absulote_x;
} CurvePoint;

typedef struct {
	const char *original_pixels;
	const CurvePoint **curves;
	int original_pitch;
	int original_w;
	int original_h;
	char *pixels;
	int pitch;
	int w;
	int h;
	int bytes_per_pixel;
	bool **buffer;
} ResizableImage;

const int SOBEL_X[3][3] = {
	{ -1,  0,  1 },
	{ -2,  0,  2 },
	{ -1,  0,  1 },
};

const int SOBEL_Y[3][3] = {
	{ -1, -2, -1 },
	{  0,  0,  0 },
	{  1,  2,  1 },
};

void **mat_alloc(int x, int y, size_t element_size)
{
	void **mat = malloc(sizeof(void *) * y);

	for (int i = 0; i < y; i++) {
		mat[i] = malloc(element_size * x);
	}

	return mat;
}

void mat_free(void **mat, int y)
{
	for (int i = 0; i < y; i++) {
		free(mat[i]);
	}

	free(mat);
}

void mat_set(void **mat, int x, int y, int c, size_t element_size)
{
	for (int i = 0; i < y; i++) {
		memset(mat[i], c, x * element_size);
	}
}

static inline int get_pixel_luminance(unsigned char r, unsigned char g, unsigned char b)
{
	return 0.299 * r + 0.587 * g + 0.114 * b;
}

void calculate_gradient(Image *img)
{
	for (int y = 0; y < img->h; y++) {
		for (int x = 0; x < img->w; x++) {

			int gx = 0;
			int gy = 0;

			for (int cy = -1; cy <= 1; cy++) {
				for (int cx = -1; cx <= 1; cx++) {
					if (in_range(0, x + cx, img->w - 1) && in_range(0, y + cy, img->h - 1)) {
						const Pixel pixel = img->pixels[y + cy][x + cx];
						int luminance = get_pixel_luminance(pixel.r, pixel.g, pixel.b);

						gx += SOBEL_X[cy + 1][cx + 1] * luminance;
						gy += SOBEL_Y[cy + 1][cx + 1] * luminance;
					}
				}
			}

			img->pixels[y][x].gradient = gx * gx + gy * gy;
		}
	}
}

void calculate_gradient_near_curve(Image *img, CurvePoint *curve)
{
	for (int y = 0; y < img->h; y++) {

		int x = curve[y].relative_x;
		for (int i = -1; i <= 1; i++) {
			for (int j = -1; j <= 1; j++) {
				int gx = 0;
				int gy = 0;

				int x0 = x + j;
				int y0 = y + i;

				for (int cy = -1; cy <= 1; cy++) {
					for (int cx = -1; cx <= 1; cx++) {
						if (in_range(0, x0 + cx, img->w - 1) && in_range(0, y0 + cy, img->h - 1)) {
							const Pixel pixel = img->pixels[y0 + cy][x0 + cx];
							int luminance = get_pixel_luminance(pixel.r, pixel.g, pixel.b);

							gx += SOBEL_X[cy + 1][cx + 1] * luminance;
							gy += SOBEL_Y[cy + 1][cx + 1] * luminance;
						}
					}
				}

				img->pixels[y][x].gradient = gx * gx + gy * gy;
			}
		}
	}
}

void calculate_vertical_gradient_sum(Image *img)
{
	for (int y = img->h - 2; y >= 0; y--) {

		// middle
		for (int x = 1; x < img->w - 1; x++) {
			img->pixels[y][x].gradient_sum = img->pixels[y][x].gradient + min3(
				img->pixels[y + 1][x - 1].gradient_sum,
				img->pixels[y + 1][x].gradient_sum,
				img->pixels[y + 1][x + 1].gradient_sum
			);
		}

		// left
		img->pixels[y][0].gradient_sum = img->pixels[y][0].gradient + min(
			img->pixels[y + 1][0].gradient_sum,
			img->pixels[y + 1][1].gradient_sum
		);

		// right
		img->pixels[y][img->w - 1].gradient_sum = img->pixels[y][img->w - 1].gradient + min(
			img->pixels[y + 1][img->w - 1].gradient_sum,
			img->pixels[y + 1][img->w - 2].gradient_sum
		);
	}
}

int get_next_x_in_curve(const Image *img, int x, int y)
{
	int min_x = x;
	int min_gradient = img->pixels[y][x].gradient_sum;

	for (int x0 = max(0, x - 1); x0 < min(x + 2, img->w); x0++) {
		if (img->pixels[y][x0].gradient_sum < min_gradient) {
			min_gradient = img->pixels[y][x0].gradient_sum;
			min_x = x0;
		}
	}

	return min_x;
}

CurvePoint *find_min_vertical_curve(const Image *img)
{
	CurvePoint *curve = malloc(sizeof(CurvePoint) * img->h);

	int min_x = 0;
	int min_grad = img->pixels[0][0].gradient_sum;

	// find first min x
	for (int x = 1; x < img->w; x++) {
		if (img->pixels[0][x].gradient_sum < min_grad) {
			min_grad = img->pixels[0][x].gradient_sum;
			min_x = x;
		}
	}

	curve[0].relative_x = min_x;

	for (int y = 1; y < img->h; y++) {
		curve[y].relative_x = get_next_x_in_curve(img, curve[y - 1].relative_x, y - 1);
	}

	for (int y = 0; y < img->h; y++) {
		curve[y].absulote_x = img->pixels[y][curve[y].relative_x].x;
	}

	return curve;
}

void remove_vertical_curve_from_image(Image *img, CurvePoint *curve)
{
	for (int i = 0; i < img->h; i++) {
		int x_to_remove = curve[i].relative_x;

		memmove(&img->pixels[i][x_to_remove],
				&img->pixels[i][x_to_remove + 1],
				sizeof(Pixel) * (img->w - x_to_remove - 1)
		);
	}
}

Image format_image(const SDL_Surface *img)
{
	Image formatted_img = {
		.pixels = (Pixel **)mat_alloc(img->w, img->h, sizeof(Pixel)),
		.w = img->w,
		.h = img->h,
	};

	for (int y = 0; y < img->h; y++) {
		for (int x = 0; x < img->w; x++) {
			memcpy(
				&formatted_img.pixels[y][x],
				&((char *)img->pixels)[y * img->pitch + (x * img->format->BytesPerPixel)],
				min(img->format->BytesPerPixel, 3)
			);

			formatted_img.pixels[y][x].x = x;
			formatted_img.pixels[y][x].y = y;
		}
	}

	return formatted_img;
}

void free_image(Image *img)
{
	mat_free((void **)img->pixels, img->h);
}

float normalize(float min, float max, float x)
{
	return (x - min) / (max - min);
}

CurvePoint **compile_vertical_curves(const SDL_Surface *sdl_image)
{
	Image img = format_image(sdl_image);

	CurvePoint **curves = malloc(sizeof(CurvePoint *) * img.w);
	int w = img.w;

	calculate_gradient(&img);

	for (int x = 0; x < w; x++) {
		calculate_vertical_gradient_sum(&img);
		curves[x] = find_min_vertical_curve(&img);
		remove_vertical_curve_from_image(&img, curves[x]);
		img.w--;
		calculate_gradient_near_curve(&img, curves[x]);
		if ((x + 1) % 10 == 0) printf("completed %d curves\n", x + 1);
	}

	free_image(&img);

	return curves;
}

void *memdup(const void *src, size_t n)
{
	void *dst = malloc(n);
	memcpy(dst, src, n);

	return dst;
}

ResizableImage create_resizable_image(const char *original_pixels, int w, int h, int pitch, int bytes_per_pixel, const CurvePoint **curves)
{
	ResizableImage img = {
		.bytes_per_pixel = bytes_per_pixel,
		.original_w = w,
		.w = w,
		.original_h = h,
		.h = h,
		.original_pitch = pitch, .pitch = pitch,
		.pixels = memdup(original_pixels, h * pitch),
		.original_pixels = original_pixels,
		.curves = curves,
		.buffer = (bool **)mat_alloc(w, h, sizeof(bool)),
	};

	return img;
}

void resize_img(ResizableImage *img, int desired_width)
{
	mat_set((void **)img->buffer, img->original_w, img->original_h, 0, sizeof(bool));

	for (int x = 0; x < img->original_w - desired_width; x++) {
		for (int y = 0; y < img->original_h; y++) {
			img->buffer[y][img->curves[x][y].absulote_x] = true;
		}
	}

	img->pitch = desired_width * img->bytes_per_pixel;
	img->w = desired_width;

	for (int y = 0; y < img->original_h; y++) {
		int x0 = 0;
		for (int x = 0; x < img->original_w; x++) {
			if (!img->buffer[y][x]) {
				memcpy(
					&img->pixels[y * img->pitch + x0 * img->bytes_per_pixel],
					&img->original_pixels[y * img->original_pitch + x * img->bytes_per_pixel],
					img->bytes_per_pixel
				);
				x0++;
			}
		}
	}
}

void window_loop(SDL_Window *window, SDL_Renderer *renderer, SDL_Texture *texture, SDL_Surface *img, CurvePoint **curves)
{
	ResizableImage resizabale_img = create_resizable_image(
			img->pixels,
			img->w,
			img->h,
			img->pitch,
			img->format->BytesPerPixel,
			(const CurvePoint **)curves
	);

	SDL_UpdateTexture(texture, NULL, resizabale_img.pixels, resizabale_img.pitch);

	for (;;) {

		SDL_Event event;
		SDL_WaitEvent(&event);

		switch (event.type) {
			case SDL_QUIT:
				return;

			case SDL_KEYDOWN:
				switch (event.key.keysym.sym) {
					case SDLK_ESCAPE: case SDLK_q: return;
				}
				break;

			case SDL_WINDOWEVENT: {

				SDL_SetRenderDrawColor(renderer, 0x28, 0x28, 0x28, 0xff);
				SDL_RenderClear(renderer);

				int window_width;
				int window_height;
				SDL_GetWindowSize(window, &window_width, &window_height);

				SDL_Rect texture_dimentions = {
					.x = 0,
					.y = 0,
					.w = resizabale_img.original_w * IMG_SCALE,
					.h = resizabale_img.original_h * IMG_SCALE,
				};

				if (window_width < resizabale_img.original_w) {
					resize_img(&resizabale_img, window_width);
					SDL_UpdateTexture(texture, NULL, resizabale_img.pixels, resizabale_img.w * resizabale_img.bytes_per_pixel);
				}

				SDL_RenderCopy(renderer, texture, NULL, &texture_dimentions);

				SDL_RenderPresent(renderer);
			} break;
		}
	}
}

void die(const char *msg)
{
	fprintf(stderr, "%s", msg);
	exit(1);
}

int main(void)
{
	SDL_Init(0);
	const char *img_name = "images/"
			// "bird.jpg";
			"surfer.jpg";
			// "clocks.jpg";
			// "tower.jpg";
			// "van.jpg";

	SDL_Surface *img = IMG_Load(img_name);

	if (!img) die("Image not found\n");

	printf("(x: %d, y: %d, channels: %d, pitch: %d)\n", img->w, img->h, img->format->BytesPerPixel, img->pitch);

	CurvePoint **curves = compile_vertical_curves(img);

	SDL_Window *window = SDL_CreateWindow(
			"Image Evolution",
			SDL_WINDOWPOS_CENTERED,
			SDL_WINDOWPOS_CENTERED,
			WINDOW_WIDTH, WINDOW_HEIGHT,
			SDL_WINDOW_RESIZABLE
	);

    SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

	SDL_Texture *texture = SDL_CreateTexture(renderer, img->format->format, 0, img->w, img->h);

	window_loop(window, renderer, texture, img, curves);

	SDL_DestroyTexture(texture);
	SDL_FreeSurface(img);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();

	return 0;
}
