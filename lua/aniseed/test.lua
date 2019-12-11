local core = require("aniseed.core")
local function ok_3f(_0_0)
  local _1_ = _0_0
  local tests_passed = _1_["tests-passed"]
  local tests = _1_["tests"]
  return (tests == tests_passed)
end
local function display_results(results, prefix)
  do
    local _1_ = results
    local tests_passed = _1_["tests-passed"]
    local tests = _1_["tests"]
    local assertions_passed = _1_["assertions-passed"]
    local assertions = _1_["assertions"]
    local function _2_()
      if ok_3f(results) then
        return "OK"
      else
        return "FAILED"
      end
    end
    print((prefix .. " " .. _2_() .. " " .. tests_passed .. "/" .. tests .. " tests and " .. assertions_passed .. "/" .. assertions .. " assertions passed."))
  end
  return results
end
local function run(module_name)
  local module = package.loaded[module_name]
  local tests = (core["table?"](module) and module["aniseed/tests"])
  if core["table?"](tests) then
    local results = {["assertions-passed"] = 0, ["tests-passed"] = 0, assertions = 0, tests = #tests}
    for label, f in pairs(tests) do
      local test_failed = false
      core.update(results, "tests", core.inc)
      do
        local prefix = ("[" .. module_name .. "/" .. label .. "]")
        do
          local _1_0, _2_0 = nil, nil
          local function _3_()
            local function _4_(...)
              core.update(results, "assertions", core.inc)
              do
                local args = {...}
                local assertion_failed = false
                do
                  local _5_0 = args
                  if ((type(_5_0) == "table") and (nil ~= _5_0[1]) and (nil ~= _5_0[2])) then
                    local x = _5_0[1]
                    local y = _5_0[2]
                    if (x ~= y) then
                      assertion_failed = true
                      test_failed = true
                      print((prefix .. " Expected '" .. core["pr-str"](x) .. "' to equal '" .. core["pr-str"](y) .. "'."))
                    end
                  elseif ((type(_5_0) == "table") and (nil ~= _5_0[1])) then
                    local x = _5_0[1]
                    if not x then
                      assertion_failed = true
                      test_failed = true
                      print((prefix .. " Expected '" .. core["pr-str"](x) .. "' to be truthy."))
                    end
                  end
                end
                if not assertion_failed then
                  return core.update(results, "assertions-passed", core.inc)
                end
              end
            end
            return f(_4_)
          end
          _1_0, _2_0 = pcall(_3_)
          if ((_1_0 == false) and (nil ~= _2_0)) then
            local err = _2_0
            do
              test_failed = true
              print((prefix .. " Exception: " .. err))
            end
          end
        end
      end
      if not test_failed then
        core.update(results, "tests-passed", core.inc)
      end
    end
    return display_results(results, ("[" .. module_name .. "]"))
  end
end
local function run_all()
  local function _1_(totals, results)
    for k, v in pairs(results) do
      totals[k] = (v + totals[k])
    end
    return totals
  end
  return display_results(core.reduce(_1_, {["assertions-passed"] = 0, ["tests-passed"] = 0, assertions = 0, tests = 0}, core.filter(core["table?"], core.map(run, core.keys(package.loaded)))), "[total]")
end
return {["aniseed/module"] = "aniseed.test", ["ok?"] = ok_3f, ["run-all"] = run_all, run = run}
