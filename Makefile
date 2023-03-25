CC=clang
CFLAGS=-c -fPIC -Wall
LDFLAGS=-shared -L. -Wl,-soname,libmylib.so
SOURCES=mylib.c
OBJECTS=$(SOURCES:.c=.o)
LIBRARY=libmylib.so

all: $(SOURCES) $(LIBRARY)

$(LIBRARY): $(OBJECTS)
	$(CC) $(LDFLAGS) $(OBJECTS) -o $@

.c.o:
	$(CC) $(CFLAGS) $< -o $@

clean:
	rm -f $(OBJECTS) $(LIBRARY)
