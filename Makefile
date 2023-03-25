lib: mylib.c
	gcc -shared -fPIC -fsanitize=address -Wall -o libmylib.so mylib.c

all: lib

clean:
	rm -f libmylib.so
