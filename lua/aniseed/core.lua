local function filter(f, xs)
  local result = {}
  for _, x in ipairs(xs) do
    if f(x) then
      table.insert(result, x)
    end
  end
  return result
end
local function map(f, xs)
  local result = {}
  for _, x in ipairs(xs) do
    table.insert(result, f(x))
  end
  return result
end
local function inc(n)
  return (n + 1)
end
local function dec(n)
  return (n - 1)
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
local function str(...)
  local result = ""
  for _, s in ipairs({...}) do
    result = (result .. s)
  end
  return result
end
return {dec = dec, filter = filter, inc = inc, map = map, slurp = slurp, spit = spit, str = str}
