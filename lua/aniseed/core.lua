local view = require("aniseed.view")
local function first(xs)
  if xs then
    return xs[1]
  end
end
local function last(xs)
  if xs then
    return xs[#xs]
  end
end
local function second(xs)
  if xs then
    return xs[2]
  end
end
local function count(xs)
  if xs then
    return table.maxn(xs)
  else
    return 0
  end
end
local function string_3f(x)
  return ("string" == type(x))
end
local function nil_3f(x)
  return (nil == x)
end
local function table_3f(x)
  return ("table" == type(x))
end
local function inc(n)
  return (n + 1)
end
local function dec(n)
  return (n - 1)
end
local function update(tbl, k, f)
  tbl[k] = f(tbl[k])
  return tbl
end
local function run_21(f, xs)
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
local function filter(f, xs)
  local result = {}
  local function _0_(x)
    if f(x) then
      return table.insert(result, x)
    end
  end
  run_21(_0_, xs)
  return result
end
local function map(f, xs)
  local result = {}
  local function _0_(x)
    local mapped = f(x)
    local function _1_()
      if (0 == select("#", mapped)) then
        return nil
      else
        return mapped
      end
    end
    return table.insert(result, _1_())
  end
  run_21(_0_, xs)
  return result
end
local function identity(x)
  return x
end
local function keys(t)
  local result = {}
  for k, _ in pairs(t) do
    table.insert(result, k)
  end
  return result
end
local function vals(t)
  local result = {}
  for _, v in pairs(t) do
    table.insert(result, v)
  end
  return result
end
local function reduce(f, init, xs)
  local result = init
  local function _0_(x)
    result = f(result, x)
    return nil
  end
  run_21(_0_, xs)
  return result
end
local function some(f, xs)
  local result = nil
  local n = 1
  while (not result and (n <= #xs)) do
    local candidate = f(xs[n])
    if candidate then
      result = candidate
    end
    n = inc(n)
  end
  return result
end
local function concat(...)
  local result = {}
  local function _0_(xs)
    local function _1_(x)
      return table.insert(result, x)
    end
    return run_21(_1_, xs)
  end
  run_21(_0_, {...})
  return result
end
local function slurp(path)
  local _0_0, _1_0 = io.open(path, "r")
  if ((_0_0 == nil) and (nil ~= _1_0)) then
    local msg = _1_0
    return print(("Could not open file: " .. msg))
  elseif (nil ~= _0_0) then
    local f = _0_0
    do
      local content = f:read("*all")
      f:close()
      return content
    end
  end
end
local function spit(path, content)
  local _0_0, _1_0 = io.open(path, "w")
  if ((_0_0 == nil) and (nil ~= _1_0)) then
    local msg = _1_0
    return print(("Could not open file: " .. msg))
  elseif (nil ~= _0_0) then
    local f = _0_0
    do
      f:write(content)
      f:close()
      return nil
    end
  end
end
local function pr_str(...)
  local function _0_(x)
    return view(x, {["one-line"] = true})
  end
  return unpack(map(_0_, {...}))
end
local function pr(...)
  return print(pr_str(...))
end
return {["aniseed/module"] = "aniseed.core", ["nil?"] = nil_3f, ["pr-str"] = pr_str, ["run!"] = run_21, ["string?"] = string_3f, ["table?"] = table_3f, concat = concat, count = count, dec = dec, filter = filter, first = first, identity = identity, inc = inc, keys = keys, last = last, map = map, pr = pr, reduce = reduce, second = second, slurp = slurp, some = some, spit = spit, update = update, vals = vals}
