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
#include "logic.c"

#define WINDOW_WIDTH	800
#define WINDOW_HEIGHT	800

#define MAT_NEW(Type, Element_Type, X, Y) ((Type){ .x = X, .y = Y, .ptr = malloc(sizeof(Element_Type) * (X) * (Y)) })
#define MAT_AT(mat, X, Y) ((mat)->ptr[(Y) * (mat)->x + (X)])

typedef struct {
  bool *ptr;
  size_t x;
  size_t y;
} Bool_Mat;

typedef struct {
  unsigned char *ptr;
  size_t x;
  size_t y;
} Luminance_Mat;

typedef struct {
  int *ptr;
  size_t x;
  size_t y;
} Gradient_Mat;

typedef struct {
  unsigned int *ptr;
  size_t x;
  size_t y;
} X_Pos_Mat;

typedef struct {
  Luminance_Mat luminance;
  X_Pos_Mat positions;
  Gradient_Mat gradient;
  Gradient_Mat gradient_sum;
	int width;
	int height;
} Horizontal_Seam_Carving_State;

typedef struct {
	unsigned int relative_x;
	unsigned int absulote_x;
} Seam_Point;

typedef struct {
	const char *original_pixels;
	Seam_Point **curves;
	int original_pitch;
	int original_w;
	int original_h;
	char *pixels;
	int pitch;
	int w;
	int h;
	Bool_Mat buffer;
} Horizontal_Dynamic_Image;

static inline int get_gradient_at_position(const Horizontal_Seam_Carving_State *state, int x, int y)
{
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

  int gx = 0;
  int gy = 0;

	for (int cy = -1; cy <= 1; cy++) {
		if (in_range(0, y + cy, state->height - 1)) {
			for (int cx = -1; cx <= 1; cx++) {
				if (in_range(0, x + cx, state->width - 1)) {
					int luminance = MAT_AT(&state->luminance, x + cx, y + cy);

					gx += SOBEL_X[cy + 1][cx + 1] * luminance;
					gy += SOBEL_Y[cy + 1][cx + 1] * luminance;
				}
			}
		}
	}

	return gx * gx + gy * gy;
}

void calculate_gradient(Horizontal_Seam_Carving_State *state)
{
	for (int y = 0; y < state->height; y++) {
		for (int x = 0; x < state->width; x++) {
      MAT_AT(&state->gradient, x, y) = get_gradient_at_position(state, x, y);
		}
	}
}

void calculate_gradient_around_removed_seam(Horizontal_Seam_Carving_State *img, Seam_Point *seam)
{
  int *gradient = img->gradient.ptr;
  int gradient_x = img->gradient.x;

	for (int y = 0; y < img->height; y++) {
		int x = seam[y].relative_x;
    int *row = gradient + (y * gradient_x);

    row[y + x] = get_gradient_at_position(img, x, y);

		if (x - 1 >= 0) {
      row[x - 1] = get_gradient_at_position(img, x - 1, y);
    }

		if (x + 1 < img->width) {
      row[x + 1] = get_gradient_at_position(img, x + 1, y);
    }
	}
}

void calculate_vertical_gradient_sum(Horizontal_Seam_Carving_State *img)
{
    int w = img->width;
    int *gradient     = img->gradient.ptr;
    int *gradient_sum = img->gradient_sum.ptr;
    int gradient_x     = img->gradient.x;
    int gradient_sum_x = img->gradient_sum.x;

    for (int y = img->height - 2; y >= 0; y--) {

        int row_gradient     = y * gradient_x;
        int row_gradient_sum      = y * gradient_sum_x;
        int row_gradient_sum_next = (y + 1) * gradient_sum_x;

        // left
        gradient_sum[row_gradient_sum + 0] = gradient[row_gradient + 0] + min(
                gradient_sum[row_gradient_sum_next + 0],
                gradient_sum[row_gradient_sum_next + 1]
        );

        // middle
        for (int x = 1; x < w - 1; x++) {
            gradient_sum[row_gradient_sum + x] = gradient[row_gradient + x] + min3(
                    gradient_sum[row_gradient_sum_next + x - 1],
                    gradient_sum[row_gradient_sum_next + x],
                    gradient_sum[row_gradient_sum_next + x + 1]
						);
        }

        // right
        gradient_sum[row_gradient_sum + w - 1] =
            gradient[row_gradient + w - 1] +
            min(
                gradient_sum[row_gradient_sum_next + w - 1],
                gradient_sum[row_gradient_sum_next + w - 2]
            );
    }
}

int get_next_x_in_seam(const Horizontal_Seam_Carving_State *img, int x, int y)
{
	int min_x = x;
	int min_gradient = MAT_AT(&img->gradient_sum, x, y);

	for (int x0 = max(0, x - 1); x0 < min(x + 2, img->width); x0++) {
    if (MAT_AT(&img->gradient_sum, x0, y) < min_gradient) {
			min_gradient = MAT_AT(&img->gradient_sum, x0, y);
			min_x = x0;
		}
	}

	return min_x;
}

Seam_Point *find_min_energy_seam(const Horizontal_Seam_Carving_State *img)
{
	Seam_Point *seam = malloc(sizeof(Seam_Point) * img->height);

	int min_x = 0;
	int min_grad = MAT_AT(&img->gradient_sum, 0, 0);

	// find first min x
	for (int x = 1; x < img->width; x++) {
		if (MAT_AT(&img->gradient_sum, x, 0) < min_grad) {
      min_grad = MAT_AT(&img->gradient_sum, x, 0);
			min_x = x;
		}
	}

	seam[0].relative_x = min_x;

	for (int y = 1; y < img->height; y++) {
		seam[y].relative_x = get_next_x_in_seam(img, seam[y - 1].relative_x, y - 1);
	}

	for (int y = 0; y < img->height; y++) {
		seam[y].absulote_x = MAT_AT(&img->positions, seam[y].relative_x, y);
	}

	return seam;
}

void remove_vertical_seam(Horizontal_Seam_Carving_State *img, Seam_Point *seam)
{
	for (int i = 0; i < img->height; i++) {
		int x_to_remove = seam[i].relative_x;
    unsigned int *row_start = &MAT_AT(&img->positions, x_to_remove, i);
    memmove(row_start, row_start + 1, sizeof(unsigned int) * (img->width - x_to_remove - 1));
	}

	for (int i = 0; i < img->height; i++) {
		int x_to_remove = seam[i].relative_x;
    unsigned char *row_start = &MAT_AT(&img->luminance, x_to_remove, i);
    memmove(row_start, row_start + 1, sizeof(unsigned char) * (img->width - x_to_remove - 1));
	}

	for (int i = 0; i < img->height; i++) {
		int x_to_remove = seam[i].relative_x;
    int *row_start = &MAT_AT(&img->gradient, x_to_remove, i);
    memmove(row_start, row_start + 1, sizeof(int) * (img->width - x_to_remove - 1));
	}
}

Horizontal_Seam_Carving_State create_horizontal_seam_carving_state(const char *pixels, int width, int height, int pitch)
{
	Horizontal_Seam_Carving_State state = {
		.width = width,
		.height = height,
    .positions = MAT_NEW(X_Pos_Mat, unsigned int, width, height),
    .luminance = MAT_NEW(Luminance_Mat, unsigned char, width, height),
    .gradient = MAT_NEW(Gradient_Mat, int, width, height),
    .gradient_sum = MAT_NEW(Gradient_Mat, int, width, height),
	};

  const int BYTES_PER_PIXEL = 3;

	for (int y = 0; y < height; y++) {
		for (int x = 0; x < width; x++) {
      unsigned char r = pixels[y * pitch + x * BYTES_PER_PIXEL];
      unsigned char g = pixels[y * pitch + x * BYTES_PER_PIXEL + 1];
      unsigned char b = pixels[y * pitch + x * BYTES_PER_PIXEL + 2];

      MAT_AT(&state.luminance, x, y) = rgb_to_luminance(r, g, b);
      MAT_AT(&state.positions, x, y) = x;
		}
	}

	return state;
}

void free_state(Horizontal_Seam_Carving_State *state)
{
  free(state->positions.ptr);
  free(state->luminance.ptr);
  free(state->gradient.ptr);
  free(state->gradient_sum.ptr);
}

Seam_Point **compile_vertical_curves(const char *pixels, int width, int height, int pitch)
{
	Horizontal_Seam_Carving_State state = create_horizontal_seam_carving_state(pixels, width, height, pitch);
	Seam_Point **seams = malloc(sizeof(Seam_Point *) * state.width);

  Progress progress = create_progress(state.width - 1);
  showoff_progress(&progress);
	calculate_gradient(&state);

	for (int x = 0; x < width; x++) {
		calculate_vertical_gradient_sum(&state);
		seams[x] = find_min_energy_seam(&state);
		remove_vertical_seam(&state, seams[x]);
		state.width--;
		calculate_gradient_around_removed_seam(&state, seams[x]);
    showoff_progress(&progress);
    set_progress(&progress, x);
	}

  showoff_progress(&progress);
	free_state(&state);

	return seams;
}


Horizontal_Dynamic_Image create_resizable_image(const char *original_pixels, int w, int h, int pitch)
{
	Horizontal_Dynamic_Image img = {
		.original_w = w,
		.w = w,
		.original_h = h,
		.h = h,
		.original_pitch = pitch, .pitch = pitch,
		.pixels = memdup(original_pixels, h * pitch),
		.original_pixels = original_pixels,
		.curves = compile_vertical_curves(original_pixels, w, h, pitch),
		.buffer = MAT_NEW(Bool_Mat, bool, w, h),
	};

	return img;
}

void resize_img(Horizontal_Dynamic_Image *img, int desired_width)
{
  memset(img->buffer.ptr, 0, img->buffer.x * img->buffer.y * sizeof(bool));

	for (int y = 0; y < img->original_h; y++) {
	  for (int x = 0; x < img->original_w - desired_width; x++) {
      MAT_AT(&img->buffer, img->curves[x][y].absulote_x, y) = true;
		}
	}

  const int BYTES_PER_PIXEL = 3;

	img->pitch = desired_width * BYTES_PER_PIXEL;
	img->w = desired_width;

	for (int y = 0; y < img->original_h; y++) {
		int x0 = 0;
		for (int x = 0; x < img->original_w; x++) {
      if (!MAT_AT(&img->buffer, x, y)) {
				memcpy(
					&img->pixels[y * img->pitch + x0 * BYTES_PER_PIXEL],
					&img->original_pixels[y * img->original_pitch + x * BYTES_PER_PIXEL],
					BYTES_PER_PIXEL
				);
				x0++;
			}
		}
	}
}

void window_loop(SDL_Window *window, SDL_Renderer *renderer, SDL_Texture *texture, SDL_Surface *img, Horizontal_Dynamic_Image *resizabale_img)
{
	SDL_UpdateTexture(texture, NULL, resizabale_img->pixels, resizabale_img->pitch);

	while (true) {

		SDL_Event event;
		SDL_WaitEvent(&event);

		switch (event.type) {
			case SDL_QUIT:
				return;

			case SDL_KEYDOWN:
				switch (event.key.keysym.sym) {
					case SDLK_ESCAPE:
					case SDLK_q:
						return;
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
					.w = resizabale_img->original_w,
					.h = resizabale_img->original_h,
				};

				if (window_width < resizabale_img->original_w) {
					resize_img(resizabale_img, window_width);
					SDL_UpdateTexture(texture, NULL, resizabale_img->pixels, resizabale_img->w * 3);
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

int main(int argc, char **argv)
{
	SDL_Init(0);

	if (argc != 2) {
    die("Please provide an image path\n");
  }

	SDL_Surface *img = IMG_Load(argv[1]);

  if (img == NULL) {
    die("Horizontal_Seam_Carving_State not found\n");
  }

	printf("(x: %d, y: %d, channels: %d, pitch: %d)\n", img->w, img->h, img->format->BytesPerPixel, img->pitch);

	Horizontal_Dynamic_Image resizabale_img = create_resizable_image(
			img->pixels,
			img->w,
			img->h,
			img->pitch
	);

	SDL_Window *window = SDL_CreateWindow(
			"Seam Carving",
			SDL_WINDOWPOS_CENTERED,
			SDL_WINDOWPOS_CENTERED,
			WINDOW_WIDTH, WINDOW_HEIGHT,
			SDL_WINDOW_RESIZABLE
	);

  SDL_Renderer *renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

	SDL_Texture *texture = SDL_CreateTexture(renderer, img->format->format, 0, img->w, img->h);

	window_loop(window, renderer, texture, img, &resizabale_img);

	SDL_DestroyTexture(texture);
	SDL_FreeSurface(img);
  SDL_DestroyRenderer(renderer);
  SDL_DestroyWindow(window);
  SDL_Quit();

	return 0;
}
