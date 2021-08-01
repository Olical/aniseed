local autoload = (require("aniseed.autoload")).autoload
local a, nvim, fs, str, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil, nil, nil, nil
local _0_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {a = "aniseed.core", fs = "aniseed.fs", nvim = "aniseed.nvim", str = "aniseed.string"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.test"}
  package.loaded["aniseed.test"] = mod_0_
  _0_ = mod_0_
end
a, nvim, fs, str, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(a, "aniseed.core"), autoload(nvim, "aniseed.nvim"), autoload(fs, "aniseed.fs"), autoload(str, "aniseed.string"), _0_, "aniseed.test", "fnl/aniseed/test.fnl"
local ok_3f
local function _2_(_1_)
  local _arg_0_ = _1_
  local tests = _arg_0_["tests"]
  local tests_passed = _arg_0_["tests-passed"]
  return (tests == tests_passed)
end
ok_3f = _2_
_2amodule_2a["ok?"] = ok_3f
_2amodule_2a["aniseed/locals"]["ok?"] = ok_3f
local display_results
local function _3_(results, prefix)
  do
    local _let_0_ = results
    local assertions = _let_0_["assertions"]
    local assertions_passed = _let_0_["assertions-passed"]
    local tests = _let_0_["tests"]
    local tests_passed = _let_0_["tests-passed"]
    local _4_
    if ok_3f(results) then
      _4_ = "OK"
    else
      _4_ = "FAILED"
    end
    a.println((prefix .. " " .. _4_ .. " " .. tests_passed .. "/" .. tests .. " tests and " .. assertions_passed .. "/" .. assertions .. " assertions passed"))
  end
  return results
end
display_results = _3_
_2amodule_2a["display-results"] = display_results
_2amodule_2a["aniseed/locals"]["display-results"] = display_results
local run
local function _4_(mod_name)
  local mod = package.loaded[mod_name]
  local tests = (a["table?"](mod) and mod["aniseed/tests"])
  if a["table?"](tests) then
    local results = {["assertions-passed"] = 0, ["tests-passed"] = 0, assertions = 0, tests = #tests}
    for label, f in pairs(tests) do
      local test_failed = false
      a.update(results, "tests", a.inc)
      do
        local prefix = ("[" .. mod_name .. "/" .. label .. "]")
        local fail
        local function _5_(desc, ...)
          test_failed = true
          local function _6_(...)
            if desc then
              return (" (" .. desc .. ")")
            else
              return ""
            end
          end
          return a.println((str.join({prefix, " ", ...}) .. _6_(...)))
        end
        fail = _5_
        local begin
        local function _6_()
          return a.update(results, "assertions", a.inc)
        end
        begin = _6_
        local pass
        local function _7_()
          return a.update(results, "assertions-passed", a.inc)
        end
        pass = _7_
        local t
        local function _8_(e, r, desc)
          begin()
          if (e == r) then
            return pass()
          else
            return fail(desc, "Expected '", a["pr-str"](e), "' but received '", a["pr-str"](r), "'")
          end
        end
        local function _9_(r, desc)
          begin()
          if r then
            return pass()
          else
            return fail(desc, "Expected truthy result but received '", a["pr-str"](r), "'")
          end
        end
        local function _10_(e, r, desc)
          begin()
          local se = a["pr-str"](e)
          local sr = a["pr-str"](r)
          if (se == sr) then
            return pass()
          else
            return fail(desc, "Expected (with pr) '", se, "' but received '", sr, "'")
          end
        end
        t = {["="] = _8_, ["ok?"] = _9_, ["pr="] = _10_}
        local _11_, _12_ = nil, nil
        local function _13_()
          return f(t)
        end
        _11_, _12_ = pcall(_13_)
        if ((_11_ == false) and (nil ~= _12_)) then
          local err = _12_
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
run = _4_
_2amodule_2a["run"] = run
_2amodule_2a["aniseed/locals"]["run"] = run
local run_all
local function _5_()
  local function _6_(totals, results)
    for k, v in pairs(results) do
      totals[k] = (v + totals[k])
    end
    return totals
  end
  return display_results(a.reduce(_6_, {["assertions-passed"] = 0, ["tests-passed"] = 0, assertions = 0, tests = 0}, a.filter(a["table?"], a.map(run, a.keys(package.loaded)))), "[total]")
end
run_all = _5_
_2amodule_2a["run-all"] = run_all
_2amodule_2a["aniseed/locals"]["run-all"] = run_all
local suite
local function _6_()
  do
    local sep = fs["path-sep"]
    local function _7_(path)
      return require(string.gsub(string.match(path, ("^test" .. sep .. "fnl" .. sep .. "(.-).fnl$")), sep, "."))
    end
    a["run!"](_7_, nvim.fn.globpath(("test" .. sep .. "fnl"), "**/*-test.fnl", false, true))
  end
  if ok_3f(run_all()) then
    return nvim.ex.q()
  else
    return nvim.ex.cq()
  end
end
suite = _6_
_2amodule_2a["suite"] = suite
_2amodule_2a["aniseed/locals"]["suite"] = suite
return nil
