local core = require("aniseed.core")
local tests = {}
local function define(label, f)
  tests[label] = f
  return nil
end
local function run()
  local results = {assertions = 0, failed = 0, passed = 0, tests = 0}
  for label, f in pairs(tests) do
    core.update(results, "tests", core.inc)
    do
      local _0_0, _1_0 = nil, nil
      local function _2_()
        local function _3_(...)
          core.update(results, "assertions", core.inc)
          do
            local args = {...}
            local failed = false
            do
              local _4_0 = args
              if ((type(_4_0) == "table") and (nil ~= _4_0[1]) and (nil ~= _4_0[2])) then
                local x = _4_0[1]
                local y = _4_0[2]
                if (x ~= y) then
                  failed = true
                  print((label .. ": Expected '" .. core["pr-str"](x) .. "' to equal '" .. core["pr-str"](y) .. "'."))
                end
              elseif ((type(_4_0) == "table") and (nil ~= _4_0[1])) then
                local x = _4_0[1]
                if not x then
                  failed = true
                  print((label .. ": Expected '" .. core["pr-str"](x) .. "' to be truthy."))
                end
              end
            end
            local _5_
            if failed then
              _5_ = "failed"
            else
              _5_ = "passed"
            end
            return core.update(results, _5_, core.inc)
          end
        end
        return f(_3_)
      end
      _0_0, _1_0 = pcall(_2_)
      if ((_0_0 == false) and (nil ~= _1_0)) then
        local err = _1_0
        do
          print((label .. ": Exception! " .. err))
          core.update(results, "failed", core.inc)
        end
      end
    end
  end
  print(("Tests complete: " .. core["pr-str"](results)))
  return results
end
return {["aniseed/module"] = "aniseed.test", define = define, run = run, tests = tests}
