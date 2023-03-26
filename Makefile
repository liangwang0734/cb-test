# $(shell module load intel/2021.1.2)

CC = icc
CFLAGS = -O0 -g -Wall -fPIC

LUAJIT_LIB = $(HOME)/gkylsoft/luajit/lib
LUAJIT_INC = $(HOME)/gkylsoft/luajit/include/luajit-2.1

GKYL_LIB = $(HOME)/gkylsoft/gkylzero/lib

LIB_NAME = mylib
LIB_SOURCES = mylib.c
LIB_OBJECTS = $(LIB_SOURCES:.c=.o)
LIB_TARGET = lib$(LIB_NAME).so

MAIN_SOURCES = c_main.c
MAIN_OBJECTS = $(MAIN_SOURCES:.c=.o)
MAIN_TARGET = c_main

MAIN_LIBS = -Wl,-rpath,$(LUAJIT_LIB) -L$(LUAJIT_LIB) -lluajit-5.1
MAIN_LIBS += -Wl,-rpath,$(GKYL_LIB) -L$(GKYL_LIB) -lgkylzero

.PHONY: all clean

all: $(LIB_TARGET) $(MAIN_TARGET)

$(LIB_TARGET): $(LIB_OBJECTS)
	$(CC) -shared -o $@ $^

$(MAIN_TARGET): $(MAIN_OBJECTS)
	$(CC) -o $@ $^ $(MAIN_LIBS)

%.o: %.c
	$(CC) $(CFLAGS) -c -o $@ $< -I$(LUAJIT_INC)

clean:
	rm -f $(LIB_OBJECTS) $(LIB_TARGET) $(MAIN_OBJECTS) $(MAIN_TARGET)

