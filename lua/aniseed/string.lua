local autoload = (require("aniseed.autoload")).autoload
local a, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil
local _0_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {a = "aniseed.core"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.string"}
  package.loaded["aniseed.string"] = mod_0_
  _0_ = mod_0_
end
a, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(a, "aniseed.core"), _0_, "aniseed.string", "fnl/aniseed/string.fnl"
local join = nil
local function _1_(...)
  local args = {...}
  local function _2_(...)
    if (2 == a.count(args)) then
      return args
    else
      return {"", a.first(args)}
    end
  end
  local _let_0_ = _2_(...)
  local sep = _let_0_[1]
  local xs = _let_0_[2]
  local len = a.count(xs)
  local result = {}
  if (len > 0) then
    for i = 1, len do
      local x = xs[i]
      local _3_
      if ("string" == type(x)) then
        _3_ = x
      elseif (nil == x) then
        _3_ = x
      else
        _3_ = a["pr-str"](x)
      end
      if _3_ then
        table.insert(result, _3_)
      else
      end
    end
  end
  return table.concat(result, sep)
end
join = _1_
_2amodule_2a["join"] = join
_2amodule_2a["aniseed/locals"]["join"] = join
local split = nil
local function _2_(s, pat)
  local done_3f = false
  local acc = {}
  local index = 1
  while not done_3f do
    local start, _end = string.find(s, pat, index)
    if ("nil" == type(start)) then
      table.insert(acc, string.sub(s, index))
      done_3f = true
    else
      table.insert(acc, string.sub(s, index, (start - 1)))
      index = (_end + 1)
    end
  end
  return acc
end
split = _2_
_2amodule_2a["split"] = split
_2amodule_2a["aniseed/locals"]["split"] = split
local blank_3f = nil
local function _3_(s)
  return (a["empty?"](s) or not string.find(s, "[^%s]"))
end
blank_3f = _3_
_2amodule_2a["blank?"] = blank_3f
_2amodule_2a["aniseed/locals"]["blank?"] = blank_3f
local triml = nil
local function _4_(s)
  return string.gsub(s, "^%s*(.-)", "%1")
end
triml = _4_
_2amodule_2a["triml"] = triml
_2amodule_2a["aniseed/locals"]["triml"] = triml
local trimr = nil
local function _5_(s)
  return string.gsub(s, "(.-)%s*$", "%1")
end
trimr = _5_
_2amodule_2a["trimr"] = trimr
_2amodule_2a["aniseed/locals"]["trimr"] = trimr
local trim = nil
local function _6_(s)
  return string.gsub(s, "^%s*(.-)%s*$", "%1")
end
trim = _6_
_2amodule_2a["trim"] = trim
_2amodule_2a["aniseed/locals"]["trim"] = trim
return nil
