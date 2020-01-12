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
  local count = core.count(xs)
  local result = ""
  if (count > 0) then
    for i = 1, count do
      local x = xs[i]
      local function _2_(...)
        if (1 == i) then
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
    end
  end
  return result
end
return {["aniseed/module"] = "aniseed.string", join = join}
