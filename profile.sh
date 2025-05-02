#!/bin/sh
gcc main.c -O3 -o exe -lm -lSDL2 -lSDL2_image -pg
./exe "$1"
gprof exe gmon.out > anal.txt
rm -rf gmon.out
