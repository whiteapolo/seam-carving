all:
	cc main.c libzatar/libzatar.a -o exe -O3 -lm -lSDL2 -lSDL2_image -Wall -Wextra

clean:
	rm -rf exe
