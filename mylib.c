// C code
#include <stdio.h>

typedef void (*FuncPtr)(const int);

struct MyStruct {
    FuncPtr callback;
};

void call_func_ptr(struct MyStruct *my_struct, const int inp) {
    my_struct->callback(inp);
}

