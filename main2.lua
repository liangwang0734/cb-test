local ffi = require("ffi")

local my_lua_func = function(inp)
   print("calling my_lua_func on", inp)
end

local cb = ffi.cast("void (*)(const int)", my_lua_func)

for c=1,3 do
   cb(c)
end
