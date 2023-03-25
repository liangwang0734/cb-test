local ffi = require("ffi")

ffi.cdef[[
   typedef void (*FuncPtr)(const int inp);

   struct MyStruct {
      FuncPtr callback;
   };

   void call_func_ptr(struct MyStruct *my_struct, const int inp);
]]

local lib = ffi.load("./libmylib.so")

local my_lua_func = function(inp)
   print("calling my_lua_func on", inp)
end

local my_type = ffi.typeof("struct MyStruct")
local my_mt = {
   __new = function(self, lua_func)
      local obj = ffi.new(MyStruct)
      obj.callback = lua_func -- implicit conversion
      return obj
   end,
}
MyStruct = ffi.metatype(my_type, my_mt)
local obj = MyStruct(my_lua_func)
print(obj, obj.callback)

local cb = ffi.cast("FuncPtr", my_lua_func)

for c=1,3 do
   print("\n>>>>>>>>>>")
   lib.call_func_ptr(obj, c)
   -- obj.callback(c)
   -- cb(c)
   print("<<<<<<<<<<\n")
end

print("done")
