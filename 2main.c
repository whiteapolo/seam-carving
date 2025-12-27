#define DELETED_GRADIENT MAX_INT

typedef struct {
  unsigned char red;
  unsigned char green;
  unsigned char blue;
} Pixel;

typedef struct {
  Pixel *ptr;
  unsigned int width;
  unsigned int height;
} Image;

typedef struct {
  unsigned char *ptr;
  unsigned int width;
  unsigned int height;
} Luminance_Image;

typedef struct {
  int gradient;
} Gradient_Pixel;

typedef struct {
  int *ptr;
  unsigned int width;
  unsigned int height;
} Gradient_Image;

typedef struct {
  unsigned int x;
  unsigned int y;
} Seam_Point;

typedef struct {
  Seam_Point *points;
  unsigned int length;
} Seam;

Luminance_Image image_to_luminance();
Gradient_Image luminance_image_to_gradient();


void main()
{

}
