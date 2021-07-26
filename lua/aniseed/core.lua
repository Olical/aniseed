local autoload
local function _0_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _0_
local view, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil
local _1_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {view = "aniseed.view"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.core"}
  package.loaded["aniseed.core"] = mod_0_
  _1_ = mod_0_
end
view, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(view, "aniseed.view"), _1_, "aniseed.core", "fnl/aniseed/core.fnl"
math.randomseed(os.time())
local rand
local function _2_(n)
  return (math.random() * (n or 1))
end
rand = _2_
_2amodule_2a["rand"] = rand
_2amodule_2a["aniseed/locals"]["rand"] = rand
local string_3f
local function _3_(x)
  return ("string" == type(x))
end
string_3f = _3_
_2amodule_2a["string?"] = string_3f
_2amodule_2a["aniseed/locals"]["string?"] = string_3f
local nil_3f
local function _4_(x)
  return (nil == x)
end
nil_3f = _4_
_2amodule_2a["nil?"] = nil_3f
_2amodule_2a["aniseed/locals"]["nil?"] = nil_3f
local table_3f
local function _5_(x)
  return ("table" == type(x))
end
table_3f = _5_
_2amodule_2a["table?"] = table_3f
_2amodule_2a["aniseed/locals"]["table?"] = table_3f
local count
local function _6_(xs)
  if table_3f(xs) then
    return table.maxn(xs)
  elseif not xs then
    return 0
  else
    return #xs
  end
end
count = _6_
_2amodule_2a["count"] = count
_2amodule_2a["aniseed/locals"]["count"] = count
local empty_3f
local function _7_(xs)
  return (0 == count(xs))
end
empty_3f = _7_
_2amodule_2a["empty?"] = empty_3f
_2amodule_2a["aniseed/locals"]["empty?"] = empty_3f
local first
local function _8_(xs)
  if xs then
    return xs[1]
  end
end
first = _8_
_2amodule_2a["first"] = first
_2amodule_2a["aniseed/locals"]["first"] = first
local second
local function _9_(xs)
  if xs then
    return xs[2]
  end
end
second = _9_
_2amodule_2a["second"] = second
_2amodule_2a["aniseed/locals"]["second"] = second
local last
local function _10_(xs)
  if xs then
    return xs[count(xs)]
  end
end
last = _10_
_2amodule_2a["last"] = last
_2amodule_2a["aniseed/locals"]["last"] = last
local inc
local function _11_(n)
  return (n + 1)
end
inc = _11_
_2amodule_2a["inc"] = inc
_2amodule_2a["aniseed/locals"]["inc"] = inc
local dec
local function _12_(n)
  return (n - 1)
end
dec = _12_
_2amodule_2a["dec"] = dec
_2amodule_2a["aniseed/locals"]["dec"] = dec
local even_3f
local function _13_(n)
  return ((n % 2) == 0)
end
even_3f = _13_
_2amodule_2a["even?"] = even_3f
_2amodule_2a["aniseed/locals"]["even?"] = even_3f
local odd_3f
local function _14_(n)
  return not even_3f(n)
end
odd_3f = _14_
_2amodule_2a["odd?"] = odd_3f
_2amodule_2a["aniseed/locals"]["odd?"] = odd_3f
local keys
local function _15_(t)
  local result = {}
  if t then
    for k, _ in pairs(t) do
      table.insert(result, k)
    end
  end
  return result
end
keys = _15_
_2amodule_2a["keys"] = keys
_2amodule_2a["aniseed/locals"]["keys"] = keys
local vals
local function _16_(t)
  local result = {}
  if t then
    for _, v in pairs(t) do
      table.insert(result, v)
    end
  end
  return result
end
vals = _16_
_2amodule_2a["vals"] = vals
_2amodule_2a["aniseed/locals"]["vals"] = vals
local kv_pairs
local function _17_(t)
  local result = {}
  if t then
    for k, v in pairs(t) do
      table.insert(result, {k, v})
    end
  end
  return result
end
kv_pairs = _17_
_2amodule_2a["kv-pairs"] = kv_pairs
_2amodule_2a["aniseed/locals"]["kv-pairs"] = kv_pairs
local run_21
local function _18_(f, xs)
  if xs then
    local nxs = count(xs)
    if (nxs > 0) then
      for i = 1, nxs do
        f(xs[i])
      end
      return nil
    end
  end
end
run_21 = _18_
_2amodule_2a["run!"] = run_21
_2amodule_2a["aniseed/locals"]["run!"] = run_21
local filter
local function _19_(f, xs)
  local result = {}
  local function _20_(x)
    if f(x) then
      return table.insert(result, x)
    end
  end
  run_21(_20_, xs)
  return result
end
filter = _19_
_2amodule_2a["filter"] = filter
_2amodule_2a["aniseed/locals"]["filter"] = filter
local map
local function _20_(f, xs)
  local result = {}
  local function _21_(x)
    local mapped = f(x)
    local function _22_()
      if (0 == select("#", mapped)) then
        return nil
      else
        return mapped
      end
    end
    return table.insert(result, _22_())
  end
  run_21(_21_, xs)
  return result
end
map = _20_
_2amodule_2a["map"] = map
_2amodule_2a["aniseed/locals"]["map"] = map
local map_indexed
local function _21_(f, xs)
  return map(f, kv_pairs(xs))
end
map_indexed = _21_
_2amodule_2a["map-indexed"] = map_indexed
_2amodule_2a["aniseed/locals"]["map-indexed"] = map_indexed
local identity
local function _22_(x)
  return x
end
identity = _22_
_2amodule_2a["identity"] = identity
_2amodule_2a["aniseed/locals"]["identity"] = identity
local reduce
local function _23_(f, init, xs)
  local result = init
  local function _24_(x)
    result = f(result, x)
    return nil
  end
  run_21(_24_, xs)
  return result
end
reduce = _23_
_2amodule_2a["reduce"] = reduce
_2amodule_2a["aniseed/locals"]["reduce"] = reduce
local some
local function _24_(f, xs)
  local result = nil
  local n = 1
  while (nil_3f(result) and (n <= count(xs))) do
    local candidate = f(xs[n])
    if candidate then
      result = candidate
    end
    n = inc(n)
  end
  return result
end
some = _24_
_2amodule_2a["some"] = some
_2amodule_2a["aniseed/locals"]["some"] = some
local butlast
local function _25_(xs)
  local total = count(xs)
  local function _27_(_26_)
    local _arg_0_ = _26_
    local n = _arg_0_[1]
    local v = _arg_0_[2]
    return (n ~= total)
  end
  return map(second, filter(_27_, kv_pairs(xs)))
end
butlast = _25_
_2amodule_2a["butlast"] = butlast
_2amodule_2a["aniseed/locals"]["butlast"] = butlast
local rest
local function _26_(xs)
  local function _28_(_27_)
    local _arg_0_ = _27_
    local n = _arg_0_[1]
    local v = _arg_0_[2]
    return (n ~= 1)
  end
  return map(second, filter(_28_, kv_pairs(xs)))
end
rest = _26_
_2amodule_2a["rest"] = rest
_2amodule_2a["aniseed/locals"]["rest"] = rest
local concat
local function _27_(...)
  local result = {}
  local function _28_(xs)
    local function _29_(x)
      return table.insert(result, x)
    end
    return run_21(_29_, xs)
  end
  run_21(_28_, {...})
  return result
end
concat = _27_
_2amodule_2a["concat"] = concat
_2amodule_2a["aniseed/locals"]["concat"] = concat
local mapcat
local function _28_(f, xs)
  return concat(unpack(map(f, xs)))
end
mapcat = _28_
_2amodule_2a["mapcat"] = mapcat
_2amodule_2a["aniseed/locals"]["mapcat"] = mapcat
local pr_str
local function _29_(...)
  local s
  local function _30_(x)
    return view.serialise(x, {["one-line"] = true})
  end
  s = table.concat(map(_30_, {...}), " ")
  if (nil_3f(s) or ("" == s)) then
    return "nil"
  else
    return s
  end
end
pr_str = _29_
_2amodule_2a["pr-str"] = pr_str
_2amodule_2a["aniseed/locals"]["pr-str"] = pr_str
local str
local function _30_(...)
  local function _31_(acc, s)
    return (acc .. s)
  end
  local function _32_(s)
    if string_3f(s) then
      return s
    else
      return pr_str(s)
    end
  end
  return reduce(_31_, "", map(_32_, {...}))
end
str = _30_
_2amodule_2a["str"] = str
_2amodule_2a["aniseed/locals"]["str"] = str
local println
local function _31_(...)
  local function _32_(acc, s)
    return (acc .. s)
  end
  local function _34_(_33_)
    local _arg_0_ = _33_
    local i = _arg_0_[1]
    local s = _arg_0_[2]
    if (1 == i) then
      return s
    else
      return (" " .. s)
    end
  end
  local function _35_(s)
    if string_3f(s) then
      return s
    else
      return pr_str(s)
    end
  end
  return print(reduce(_32_, "", map_indexed(_34_, map(_35_, {...}))))
end
println = _31_
_2amodule_2a["println"] = println
_2amodule_2a["aniseed/locals"]["println"] = println
local pr
local function _32_(...)
  return println(pr_str(...))
end
pr = _32_
_2amodule_2a["pr"] = pr
_2amodule_2a["aniseed/locals"]["pr"] = pr
local slurp
local function _33_(path, silent_3f)
  local _34_, _35_ = io.open(path, "r")
  if ((_34_ == nil) and (nil ~= _35_)) then
    local msg = _35_
    return nil
  elseif (nil ~= _34_) then
    local f = _34_
    local content = f:read("*all")
    f:close()
    return content
  end
end
slurp = _33_
_2amodule_2a["slurp"] = slurp
_2amodule_2a["aniseed/locals"]["slurp"] = slurp
local spit
local function _34_(path, content)
  local _35_, _36_ = io.open(path, "w")
  if ((_35_ == nil) and (nil ~= _36_)) then
    local msg = _36_
    return error(("Could not open file: " .. msg))
  elseif (nil ~= _35_) then
    local f = _35_
    f:write(content)
    f:close()
    return nil
  end
end
spit = _34_
_2amodule_2a["spit"] = spit
_2amodule_2a["aniseed/locals"]["spit"] = spit
local merge_21
local function _35_(base, ...)
  local function _36_(acc, m)
    if m then
      for k, v in pairs(m) do
        acc[k] = v
      end
    end
    return acc
  end
  return reduce(_36_, (base or {}), {...})
end
merge_21 = _35_
_2amodule_2a["merge!"] = merge_21
_2amodule_2a["aniseed/locals"]["merge!"] = merge_21
local merge
local function _36_(...)
  return merge_21({}, ...)
end
merge = _36_
_2amodule_2a["merge"] = merge
_2amodule_2a["aniseed/locals"]["merge"] = merge
local select_keys
local function _37_(t, ks)
  if (t and ks) then
    local function _38_(acc, k)
      if k then
        acc[k] = t[k]
      end
      return acc
    end
    return reduce(_38_, {}, ks)
  else
    return {}
  end
end
select_keys = _37_
_2amodule_2a["select-keys"] = select_keys
_2amodule_2a["aniseed/locals"]["select-keys"] = select_keys
local get
local function _38_(t, k, d)
  local res
  if table_3f(t) then
    local val = t[k]
    if not nil_3f(val) then
      res = val
    else
    res = nil
    end
  else
  res = nil
  end
  if nil_3f(res) then
    return d
  else
    return res
  end
end
get = _38_
_2amodule_2a["get"] = get
_2amodule_2a["aniseed/locals"]["get"] = get
local get_in
local function _39_(t, ks, d)
  local res
  local function _40_(acc, k)
    if table_3f(acc) then
      return get(acc, k)
    end
  end
  res = reduce(_40_, t, ks)
  if nil_3f(res) then
    return d
  else
    return res
  end
end
get_in = _39_
_2amodule_2a["get-in"] = get_in
_2amodule_2a["aniseed/locals"]["get-in"] = get_in
local assoc
local function _40_(t, ...)
  local _let_0_ = {...}
  local k = _let_0_[1]
  local v = _let_0_[2]
  local xs = {(table.unpack or unpack)(_let_0_, 3)}
  local rem = count(xs)
  local t0 = (t or {})
  if odd_3f(rem) then
    error("assoc expects even number of arguments after table, found odd number")
  end
  if not nil_3f(k) then
    t0[k] = v
  end
  if (rem > 0) then
    assoc(t0, unpack(xs))
  end
  return t0
end
assoc = _40_
_2amodule_2a["assoc"] = assoc
_2amodule_2a["aniseed/locals"]["assoc"] = assoc
local assoc_in
local function _41_(t, ks, v)
  local path = butlast(ks)
  local final = last(ks)
  local t0 = (t or {})
  local function _42_(acc, k)
    local step = get(acc, k)
    if nil_3f(step) then
      return get(assoc(acc, k, {}), k)
    else
      return step
    end
  end
  assoc(reduce(_42_, t0, path), final, v)
  return t0
end
assoc_in = _41_
_2amodule_2a["assoc-in"] = assoc_in
_2amodule_2a["aniseed/locals"]["assoc-in"] = assoc_in
local update
local function _42_(t, k, f)
  return assoc(t, k, f(get(t, k)))
end
update = _42_
_2amodule_2a["update"] = update
_2amodule_2a["aniseed/locals"]["update"] = update
local update_in
local function _43_(t, ks, f)
  return assoc_in(t, ks, f(get_in(t, ks)))
end
update_in = _43_
_2amodule_2a["update-in"] = update_in
_2amodule_2a["aniseed/locals"]["update-in"] = update_in
local constantly
local function _44_(v)
  local function _45_()
    return v
  end
  return _45_
end
constantly = _44_
_2amodule_2a["constantly"] = constantly
_2amodule_2a["aniseed/locals"]["constantly"] = constantly
return nil
