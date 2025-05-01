#ifndef UTIL_H
#define UTIL_H

#include <stdint.h>

static inline int in_range(int min, int x, int max) { return min <= x && x <= max; }
static inline int min(int a, int b) { return a < b ? a : b; }
static inline int max(int a, int b) { return a > b ? a : b; }
static inline int min3(int a, int b, int c) { return min(min(a, b), c); }
static inline int max3(int a, int b, int c) { return max(max(a, b), c); }

typedef int8_t   i8;
typedef int16_t  i16;
typedef int32_t  i32;
typedef int64_t  i64;

typedef uint8_t  u8;
typedef uint16_t u16;
typedef uint32_t u32;
typedef uint64_t u64;

#endif
