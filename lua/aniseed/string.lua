local _0_0 = nil
do
  local name_23_0_ = "aniseed.string"
  local loaded_23_0_ = package.loaded[name_23_0_]
  local _1_0 = nil
  if (("table" == type(loaded_23_0_)) and loaded_23_0_["aniseed/module"]) then
    _1_0 = loaded_23_0_
  else
    _1_0 = {}
  end
  _1_0["aniseed/module"] = name_23_0_
  _1_0["aniseed/requires"] = {}
  _1_0["aniseed/requires"]["something"] = true
  do local _ = {nil} end
  _0_0 = _1_0
end
local core = require("aniseed.core")
local join = nil
do
  local v_23_0_ = nil
  local function join0(...)
    local args = {...}
    local function _2_(...)
      if (2 == #args) then
        return args
      else
        return {"", core.first(args)}
      end
    end
    local _3_ = _2_(...)
    local sep = _3_[1]
    local xs = _3_[2]
    local count = core.count(xs)
    local result = ""
    if (count > 0) then
      for i = 1, count do
        local x = xs[i]
        local function _4_(...)
          if (1 == i) then
            return ""
          else
            return sep
          end
        end
        local function _5_(...)
          if core["string?"](x) then
            return x
          elseif core["nil?"](x) then
            return ""
          else
            return core["pr-str"](x)
          end
        end
        result = (result .. _4_(...) .. _5_(...))
      end
    end
    return result
  end
  v_23_0_ = join0
  _0_0["join"] = v_23_0_
  join = v_23_0_
end
return _0_0
