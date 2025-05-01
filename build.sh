#!/bin/sh
gcc main.c -O3 -o exe -g -lm -lSDL2 -lSDL2_image -lpthread -pg
