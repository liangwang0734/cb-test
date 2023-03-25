#include <stdio.h>

typedef void (*FuncPtr)(const int);

struct MyStruct {
  FuncPtr callback;
};

void call_func_ptr(struct MyStruct *my_struct, const int inp) {
  printf("c side: call_func_ptr MyStruct %p -> callback %p\n", my_struct,
      my_struct->callback);
  my_struct->callback(inp);
  printf("c side: call_func_ptr done\n");
}

