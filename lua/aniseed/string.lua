local core = require("aniseed.core")
local function join(...)
  local args = {...}
  local function _0_(...)
    if (2 == #args) then
      return args
    else
      return {"", core.first(args)}
    end
  end
  local _1_ = _0_(...)
  local sep = _1_[1]
  local xs = _1_[2]
  local result = ""
  local first_3f = true
  for _, x in ipairs(xs) do
    local function _2_(...)
      if first_3f then
        return ""
      else
        return sep
      end
    end
    local function _3_(...)
      if core["string?"](x) then
        return x
      elseif core["nil?"](x) then
        return ""
      else
        return core["pr-str"](x)
      end
    end
    result = (result .. _2_(...) .. _3_(...))
    first_3f = false
  end
  return result
end
return {["aniseed/module"] = "aniseed.string", join = join}
