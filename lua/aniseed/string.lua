local _0_0 = nil
do
  local name_23_0_ = "aniseed.string"
  local loaded_23_0_ = package.loaded[name_23_0_]
  if (("table" == type(loaded_23_0_)) and loaded_23_0_["aniseed/module"]) then
    _0_0 = loaded_23_0_
  else
    _0_0 = {["aniseed/module"] = name_23_0_}
  end
end
local core = require("aniseed.core")
local join = join
do
  local v_23_0_ = nil
  local function join(...)
    local args = {...}
    local function _1_(...)
      if (2 == #args) then
        return args
      else
        return {"", core.first(args)}
      end
    end
    local _2_ = _1_(...)
    local sep = _2_[1]
    local xs = _2_[2]
    local count = core.count(xs)
    local result = ""
    if (count > 0) then
      for i = 1, count do
        local x = xs[i]
        local function _3_(...)
          if (1 == i) then
            return ""
          else
            return sep
          end
        end
        local function _4_(...)
          if core["string?"](x) then
            return x
          elseif core["nil?"](x) then
            return ""
          else
            return core["pr-str"](x)
          end
        end
        result = (result .. _3_(...) .. _4_(...))
      end
    end
    return result
  end
  v_23_0_ = join
  _0_0["join"] = v_23_0_
  join = v_23_0_
end
core.pr(join)
return _0_0
