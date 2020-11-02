local _0_0 = nil
do
  local _2_0 = "aniseed.test"
  local _1_0 = {}
  package.loaded[_2_0] = _1_0
  _0_0 = _1_0
end
local _3_ = {require("aniseed.core"), require("aniseed.nvim"), require("aniseed.string")}
local a = _3_[1]
local nvim = _3_[2]
local str = _3_[3]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "aniseed.test"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local ok_3f = nil
do
  local v_0_ = nil
  local function ok_3f0(_4_0)
    local _5_ = _4_0
    local tests = _5_["tests"]
    local tests_passed = _5_["tests-passed"]
    return (tests == tests_passed)
  end
  v_0_ = ok_3f0
  _0_0["ok?"] = v_0_
  ok_3f = v_0_
end
local display_results = nil
do
  local v_0_ = nil
  local function display_results0(results, prefix)
    do
      local _4_ = results
      local assertions = _4_["assertions"]
      local assertions_passed = _4_["assertions-passed"]
      local tests = _4_["tests"]
      local tests_passed = _4_["tests-passed"]
      local function _5_()
        if ok_3f(results) then
          return "OK"
        else
          return "FAILED"
        end
      end
      a.println((prefix .. " " .. _5_() .. " " .. tests_passed .. "/" .. tests .. " tests and " .. assertions_passed .. "/" .. assertions .. " assertions passed"))
    end
    return results
  end
  v_0_ = display_results0
  _0_0["display-results"] = v_0_
  display_results = v_0_
end
local run = nil
do
  local v_0_ = nil
  local function run0(mod_name)
    local mod = package.loaded[mod_name]
    local tests = (a["table?"](mod) and mod["aniseed/tests"])
    if a["table?"](tests) then
      local results = {["assertions-passed"] = 0, ["tests-passed"] = 0, assertions = 0, tests = #tests}
      for label, f in pairs(tests) do
        local test_failed = false
        a.update(results, "tests", a.inc)
        do
          local prefix = ("[" .. mod_name .. "/" .. label .. "]")
          local fail = nil
          local function _4_(desc, ...)
            test_failed = true
            local function _5_(...)
              if desc then
                return (" (" .. desc .. ")")
              else
                return ""
              end
            end
            return a.println((str.join({prefix, " ", ...}) .. _5_(...)))
          end
          fail = _4_
          local begin = nil
          local function _5_()
            return a.update(results, "assertions", a.inc)
          end
          begin = _5_
          local pass = nil
          local function _6_()
            return a.update(results, "assertions-passed", a.inc)
          end
          pass = _6_
          local t = nil
          local function _7_(e, r, desc)
            begin()
            if (e == r) then
              return pass()
            else
              return fail(desc, "Expected '", a["pr-str"](e), "' but received '", a["pr-str"](r), "'")
            end
          end
          local function _8_(r, desc)
            begin()
            if r then
              return pass()
            else
              return fail(desc, "Expected truthy result but received '", a["pr-str"](r), "'")
            end
          end
          local function _9_(e, r, desc)
            begin()
            local se = a["pr-str"](e)
            local sr = a["pr-str"](r)
            if (se == sr) then
              return pass()
            else
              return fail(desc, "Expected (with pr) '", se, "' but received '", sr, "'")
            end
          end
          t = {["="] = _7_, ["ok?"] = _8_, ["pr="] = _9_}
          local _10_0, _11_0 = nil, nil
          local function _12_()
            return f(t)
          end
          _10_0, _11_0 = pcall(_12_)
          if ((_10_0 == false) and (nil ~= _11_0)) then
            local err = _11_0
            fail("Exception: ", err)
          end
        end
        if not test_failed then
          a.update(results, "tests-passed", a.inc)
        end
      end
      return display_results(results, ("[" .. mod_name .. "]"))
    end
  end
  v_0_ = run0
  _0_0["run"] = v_0_
  run = v_0_
end
local run_all = nil
do
  local v_0_ = nil
  local function run_all0()
    local function _4_(totals, results)
      for k, v in pairs(results) do
        totals[k] = (v + totals[k])
      end
      return totals
    end
    return display_results(a.reduce(_4_, {["assertions-passed"] = 0, ["tests-passed"] = 0, assertions = 0, tests = 0}, a.filter(a["table?"], a.map(run, a.keys(package.loaded)))), "[total]")
  end
  v_0_ = run_all0
  _0_0["run-all"] = v_0_
  run_all = v_0_
end
local suite = nil
do
  local v_0_ = nil
  local function suite0()
    nvim.ex.redir_("> test/results.txt")
    local function _4_(path)
      return require(string.gsub(string.match(path, "^test/fnl/(.-).fnl$"), "/", "."))
    end
    a["run!"](_4_, nvim.fn.globpath("test/fnl", "**/*-test.fnl", false, true))
    local results = run_all()
    nvim.ex.redir("END")
    if ok_3f(results) then
      return nvim.ex.q()
    else
      return nvim.ex.cq()
    end
  end
  v_0_ = suite0
  _0_0["suite"] = v_0_
  suite = v_0_
end
return nil
