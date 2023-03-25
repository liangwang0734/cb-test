local ffi = require("ffi")

ffi.cdef[[
   typedef void (*FuncPtr)(const int inp);

   struct MyStruct {
      FuncPtr callback;
   };

   void call_func_ptr(struct MyStruct *my_struct, const int inp);
]]

local lib = ffi.load("/home/lw6/scratch/mirror/test03/libmylib.so")

local my_type = ffi.typeof("struct MyStruct")

local my_mt = {
   __new = function(self, lua_func)
      local obj = ffi.new(MyStruct)
      obj.callback = lua_func
      return obj
   end,
}

MyStruct = ffi.metatype(my_type, my_mt)

local kernel = function(inp)
   return inp*10
end

local my_lua_func = function(inp)
   print("calling my_lua_func on", inp)
   print("calling kernel", kernel(inp))
end

local obj = MyStruct(my_lua_func)

print(obj, obj.callback)

for c=1,2 do
   lib.call_func_ptr(obj, 123)
end

print("done")
