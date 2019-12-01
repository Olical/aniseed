local nvim = require("aniseed.nvim")
local function normal(keys)
  return nvim.ex.silent(("exe \"normal! " .. keys .. "\""))
end
local function fn_bridge(viml_name, module, lua_name, opts)
  local _0_ = (opts or {})
  local range = _0_["range"]
  local _return = _0_["return"]
  local function _1_()
    if range then
      return " range"
    else
      return ""
    end
  end
  local function _2_()
    if _return then
      return "return"
    else
      return "call"
    end
  end
  local function _3_()
    if range then
      return "\" . a:firstline . \", \" . a:lastline . \", "
    else
      return ""
    end
  end
  return nvim.ex.function_((viml_name .. "(...)" .. _1_() .. "\n          " .. _2_() .. " luaeval(\"require('" .. module .. "')['" .. lua_name .. "'](" .. _3_() .. "unpack(_A))\", a:000)\n          endfunction"))
end
return {["aniseed/module"] = "aniseed.nvim.util", ["fn-bridge"] = fn_bridge, normal = normal}
