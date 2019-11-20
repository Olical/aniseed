local nvim = require("aniseed.nvim")
local function normal(keys)
  return nvim.ex.silent(("exe \"normal! " .. keys .. "\""))
end
local function fn_bridge(viml_name, module, lua_name, ...)
  local _0_ = {...}
  local opts = _0_[1]
  local _1_ = (opts or {})
  local range = _1_["range"]
  local function _2_(...)
    if range then
      return " range"
    else
      return ""
    end
  end
  local function _3_(...)
    if range then
      return "\" . a:firstline . \", \" . a:lastline . \", "
    else
      return ""
    end
  end
  return nvim.ex.function_((viml_name .. "(...)" .. _2_(...) .. "\n          call luaeval(\"require('" .. module .. "')['" .. lua_name .. "'](" .. _3_(...) .. "unpack(_A))\", a:000)\n          endfunction"))
end
return {["fn-bridge"] = fn_bridge, normal = normal}
