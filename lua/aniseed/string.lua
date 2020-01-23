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
local _1_ = {}
do local _ = {nil, nil} end
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
do
  local locals_23_0_ = (_0_0["aniseed/locals"] or {})
  local done_3f_23_0_ = false
  local n_23_0_ = 1
  while not done_3f_23_0_ do
    local name_23_0_, value_23_0_ = debug.getlocal(1, n_23_0_)
    if name_23_0_ then
      n_23_0_ = (n_23_0_ + 1)
      locals_23_0_[name_23_0_] = value_23_0_
    else
      done_3f_23_0_ = true
    end
  end
  _0_0["aniseed/locals"] = locals_23_0_
  return _0_0
end
