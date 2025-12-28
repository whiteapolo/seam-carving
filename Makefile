all:
	cc main.c -o exe -O3 -lm -lSDL2 -lSDL2_image -Wall

profile:
	gcc main.c -O3 -o exe -lm -lSDL2 -lSDL2_image -pg
	./exe "./images/surfer.jpg"
	gprof exe gmon.out > anal.txt
	rm -rf gmon.out

clean:
	rm -rf exe
