local nvim = require("aniseed.nvim")
local function normal(keys)
  return nvim.ex.silent(("exe \"normal! " .. keys .. "\""))
end
local function fn_bridge(viml_name, module, lua_name)
  return nvim.ex.function_((viml_name .. "(...)\n        call luaeval(\"require('" .. module .. "')['" .. lua_name .. "'](unpack(_A))\", a:000)\n        endfunction"))
end
return {["fn-bridge"] = fn_bridge, normal = normal}
