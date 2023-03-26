$(module load intel/2021.1.2)

CC = icc
CFLAGS = -O0 -g -Wall

LUAJIT_LIB = ${HOME}/gkylsoft/luajit/lib
LUAJIT_INC = ${HOME}/gkylsoft/luajit/include/luajit-2.1

GKYLZERO_LIB = ${HOME}/gkylsoft/gkylzero/lib
GKYLZERO_INC = ${HOME}/gkylsoft/gkylzero/include

LIB_NAME = mylib
LIB_SOURCES = mylib.c
LIB_OBJECTS = $(LIB_SOURCES:.c=.o)
LIB_CFLAGS = -fPIC

MAIN_NAME = c_main
MAIN_SOURCES = c_main.c
MAIN_OBJECTS = $(MAIN_SOURCES:.c=.o)
MAIN_LIBS = -L. -l$(LIB_NAME) -L$(LUAJIT_LIB) -lluajit-5.1 -L$(GKYLZERO_LIB) -lgkylzero

.PHONY: all clean

all: lib$(LIB_NAME).so $(MAIN_NAME)

lib$(LIB_NAME).so: $(LIB_OBJECTS)
	$(CC) -shared $(LIB_CFLAGS) $(CFLAGS) $(LIB_OBJECTS) -o lib$(LIB_NAME).so

$(MAIN_NAME): $(MAIN_OBJECTS)
	$(CC) $(CFLAGS) $(MAIN_OBJECTS) $(MAIN_LIBS) -o $(MAIN_NAME)

%.o: %.c
	$(CC) $(CFLAGS) $(LIB_CFLAGS) -I$(LUAJIT_INC) -I$(GKYLZERO_INC) -c $< -o $@

clean:
	rm -f *.o *.so $(MAIN_NAME)

