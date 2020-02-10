local _0_0 = nil
do
  local name_23_0_ = "aniseed.core"
  local loaded_23_0_ = package.loaded[name_23_0_]
  local module_23_0_ = nil
  if ("table" == type(loaded_23_0_)) then
    module_23_0_ = loaded_23_0_
  else
    module_23_0_ = {}
  end
  module_23_0_["aniseed/module"] = name_23_0_
  module_23_0_["aniseed/locals"] = (module_23_0_["aniseed/locals"] or {})
  module_23_0_["aniseed/local-fns"] = (module_23_0_["aniseed/local-fns"] or {})
  package.loaded[name_23_0_] = module_23_0_
  _0_0 = module_23_0_
end
local function _1_(...)
  _0_0["aniseed/local-fns"] = {require = {view = "aniseed.view"}}
  return {require("aniseed.view")}
end
local _2_ = _1_(...)
local view = _2_[1]
do local _ = ({nil, _0_0, nil})[2] end
local first = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function first0(xs)
      if xs then
        return xs[1]
      end
    end
    v_23_0_0 = first0
    _0_0["first"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["first"] = v_23_0_
  first = v_23_0_
end
local last = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function last0(xs)
      if xs then
        return xs[#xs]
      end
    end
    v_23_0_0 = last0
    _0_0["last"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["last"] = v_23_0_
  last = v_23_0_
end
local second = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function second0(xs)
      if xs then
        return xs[2]
      end
    end
    v_23_0_0 = second0
    _0_0["second"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["second"] = v_23_0_
  second = v_23_0_
end
local count = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function count0(xs)
      if xs then
        return table.maxn(xs)
      else
        return 0
      end
    end
    v_23_0_0 = count0
    _0_0["count"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["count"] = v_23_0_
  count = v_23_0_
end
local string_3f = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function string_3f0(x)
      return ("string" == type(x))
    end
    v_23_0_0 = string_3f0
    _0_0["string?"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["string?"] = v_23_0_
  string_3f = v_23_0_
end
local nil_3f = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function nil_3f0(x)
      return (nil == x)
    end
    v_23_0_0 = nil_3f0
    _0_0["nil?"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["nil?"] = v_23_0_
  nil_3f = v_23_0_
end
local table_3f = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function table_3f0(x)
      return ("table" == type(x))
    end
    v_23_0_0 = table_3f0
    _0_0["table?"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["table?"] = v_23_0_
  table_3f = v_23_0_
end
local inc = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function inc0(n)
      return (n + 1)
    end
    v_23_0_0 = inc0
    _0_0["inc"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["inc"] = v_23_0_
  inc = v_23_0_
end
local dec = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function dec0(n)
      return (n - 1)
    end
    v_23_0_0 = dec0
    _0_0["dec"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["dec"] = v_23_0_
  dec = v_23_0_
end
local update = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function update0(tbl, k, f)
      tbl[k] = f(tbl[k])
      return tbl
    end
    v_23_0_0 = update0
    _0_0["update"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["update"] = v_23_0_
  update = v_23_0_
end
local run_21 = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function run_210(f, xs)
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
    v_23_0_0 = run_210
    _0_0["run!"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["run!"] = v_23_0_
  run_21 = v_23_0_
end
local filter = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function filter0(f, xs)
      local result = {}
      local function _3_(x)
        if f(x) then
          return table.insert(result, x)
        end
      end
      run_21(_3_, xs)
      return result
    end
    v_23_0_0 = filter0
    _0_0["filter"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["filter"] = v_23_0_
  filter = v_23_0_
end
local map = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function map0(f, xs)
      local result = {}
      local function _3_(x)
        local mapped = f(x)
        local function _4_()
          if (0 == select("#", mapped)) then
            return nil
          else
            return mapped
          end
        end
        return table.insert(result, _4_())
      end
      run_21(_3_, xs)
      return result
    end
    v_23_0_0 = map0
    _0_0["map"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["map"] = v_23_0_
  map = v_23_0_
end
local identity = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function identity0(x)
      return x
    end
    v_23_0_0 = identity0
    _0_0["identity"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["identity"] = v_23_0_
  identity = v_23_0_
end
local keys = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function keys0(t)
      local result = {}
      for k, _ in pairs(t) do
        table.insert(result, k)
      end
      return result
    end
    v_23_0_0 = keys0
    _0_0["keys"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["keys"] = v_23_0_
  keys = v_23_0_
end
local vals = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function vals0(t)
      local result = {}
      for _, v in pairs(t) do
        table.insert(result, v)
      end
      return result
    end
    v_23_0_0 = vals0
    _0_0["vals"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["vals"] = v_23_0_
  vals = v_23_0_
end
local reduce = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function reduce0(f, init, xs)
      local result = init
      local function _3_(x)
        result = f(result, x)
        return nil
      end
      run_21(_3_, xs)
      return result
    end
    v_23_0_0 = reduce0
    _0_0["reduce"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["reduce"] = v_23_0_
  reduce = v_23_0_
end
local some = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function some0(f, xs)
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
    v_23_0_0 = some0
    _0_0["some"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["some"] = v_23_0_
  some = v_23_0_
end
local concat = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function concat0(...)
      local result = {}
      local function _3_(xs)
        local function _4_(x)
          return table.insert(result, x)
        end
        return run_21(_4_, xs)
      end
      run_21(_3_, {...})
      return result
    end
    v_23_0_0 = concat0
    _0_0["concat"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["concat"] = v_23_0_
  concat = v_23_0_
end
local slurp = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function slurp0(path)
      local _3_0, _4_0 = io.open(path, "r")
      if ((_3_0 == nil) and (nil ~= _4_0)) then
        local msg = _4_0
        return print(("Could not open file: " .. msg))
      elseif (nil ~= _3_0) then
        local f = _3_0
        do
          local content = f:read("*all")
          f:close()
          return content
        end
      end
    end
    v_23_0_0 = slurp0
    _0_0["slurp"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["slurp"] = v_23_0_
  slurp = v_23_0_
end
local spit = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function spit0(path, content)
      local _3_0, _4_0 = io.open(path, "w")
      if ((_3_0 == nil) and (nil ~= _4_0)) then
        local msg = _4_0
        return print(("Could not open file: " .. msg))
      elseif (nil ~= _3_0) then
        local f = _3_0
        do
          f:write(content)
          f:close()
          return nil
        end
      end
    end
    v_23_0_0 = spit0
    _0_0["spit"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["spit"] = v_23_0_
  spit = v_23_0_
end
local pr_str = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function pr_str0(...)
      local function _3_(x)
        return view.serialise(x, {["one-line"] = true})
      end
      return unpack(map(_3_, {...}))
    end
    v_23_0_0 = pr_str0
    _0_0["pr-str"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["pr-str"] = v_23_0_
  pr_str = v_23_0_
end
local pr = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function pr0(...)
      return print(pr_str(...))
    end
    v_23_0_0 = pr0
    _0_0["pr"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["pr"] = v_23_0_
  pr = v_23_0_
end
return nil
