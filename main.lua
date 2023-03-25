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

-- lua wrapper of c struct, which implicitly converts my_lua_func
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

-- isolated callback from cast
local cb = ffi.cast("FuncPtr", my_lua_func)

for c=1,3 do
   print("\n>>>>>>>>>>")
   -- following fails if only obj or cb is created
   lib.call_func_ptr(obj, c) -- OK if obj is created after cb
   -- obj.callback(c) -- OK if obj is created after cb
   -- cb(c) -- OK if cb is created after obj
   print("<<<<<<<<<<\n")
end

print("done")
