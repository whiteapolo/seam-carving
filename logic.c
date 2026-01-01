#include <stdio.h>
#include <string.h>
#include "zlib/include/z_time.h"

typedef struct {
  int whatineedtodo;
  int whatihavedone;
  int lastprogresspersantage;
  Z_Clock big_bang;
} Progress;

static inline bool in_range(int min, int val, int max);
static inline unsigned char rgb_to_luminance(unsigned char r, unsigned char g, unsigned char b);
static inline int max(int a, int b);
static inline int min(int a, int b);
static inline int min3(int a, int b, int c);
void *memdup(const void *mem, const size_t size);

Progress create_progress(int whatineedtodo);
void set_progress(Progress *progress, int whatihavedone);
void showoff_progress(Progress *progress);

static inline bool in_range(int min, int val, int max)
{
	return min <= val && val <= max;
}

static inline unsigned char rgb_to_luminance(unsigned char r, unsigned char g, unsigned char b)
{
	return 0.299 * r + 0.587 * g + 0.114 * b;
}

static inline int max(int a, int b)
{
	return a > b ? a : b;
}

static inline int min(int a, int b)
{
	return a > b ? b : a;
}

static inline int min3(int a, int b, int c)
{
	return min(a, min(b, c));
}

void *memdup(const void *mem, const size_t size)
{
	void *newMem = malloc(size);
	memcpy(newMem, mem, size);
	return newMem;
}

Progress create_progress(int whatineedtodo)
{
  Progress progress = {
    .whatineedtodo = whatineedtodo,
    .whatihavedone = 0,
    .lastprogresspersantage = -1,
    .big_bang = z_get_clock(),
  };

  return progress;
}

void set_progress(Progress *progress, int whatihavedone)
{
  progress->whatihavedone = whatihavedone;
}

void showoff_progress(Progress *progress)
{
  printf("\033[K");
  int perentage = progress->whatihavedone * 100 / progress->whatineedtodo;

  if (perentage == 100) {
    printf("\rDone. took ");
    z_print_elapsed_seconds(progress->big_bang);
    return;
  }

  // avoid printing when progress hasn't improved
  if (progress->lastprogresspersantage == perentage) {
    return;
  }

  printf("\r%d%%", perentage);
  fflush(stdout);
  progress->lastprogresspersantage = perentage;
}
