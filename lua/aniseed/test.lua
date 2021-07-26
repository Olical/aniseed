local autoload
local function _0_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _0_
local a, fs, str, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil, nil, nil, nil
local _1_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {a = "aniseed.core", fs = "aniseed.fs", nvim = "aniseed.nvim", str = "aniseed.string"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.test"}
  package.loaded["aniseed.test"] = mod_0_
  _1_ = mod_0_
end
a, fs, str, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(a, "aniseed.core"), autoload(fs, "aniseed.fs"), autoload(str, "aniseed.string"), autoload(nvim, "aniseed.nvim"), _1_, "aniseed.test", "fnl/aniseed/test.fnl"
local ok_3f
local function _3_(_2_)
  local _arg_0_ = _2_
  local tests = _arg_0_["tests"]
  local tests_passed = _arg_0_["tests-passed"]
  return (tests == tests_passed)
end
ok_3f = _3_
_2amodule_2a["ok?"] = ok_3f
_2amodule_2a["aniseed/locals"]["ok?"] = ok_3f
local display_results
local function _4_(results, prefix)
  do
    local _let_0_ = results
    local assertions = _let_0_["assertions"]
    local assertions_passed = _let_0_["assertions-passed"]
    local tests = _let_0_["tests"]
    local tests_passed = _let_0_["tests-passed"]
    local _5_
    if ok_3f(results) then
      _5_ = "OK"
    else
      _5_ = "FAILED"
    end
    a.println((prefix .. " " .. _5_ .. " " .. tests_passed .. "/" .. tests .. " tests and " .. assertions_passed .. "/" .. assertions .. " assertions passed"))
  end
  return results
end
display_results = _4_
_2amodule_2a["display-results"] = display_results
_2amodule_2a["aniseed/locals"]["display-results"] = display_results
local run
local function _5_(mod_name)
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
        local function _6_(desc, ...)
          test_failed = true
          local function _7_(...)
            if desc then
              return (" (" .. desc .. ")")
            else
              return ""
            end
          end
          return a.println((str.join({prefix, " ", ...}) .. _7_(...)))
        end
        fail = _6_
        local begin
        local function _7_()
          return a.update(results, "assertions", a.inc)
        end
        begin = _7_
        local pass
        local function _8_()
          return a.update(results, "assertions-passed", a.inc)
        end
        pass = _8_
        local t
        local function _9_(e, r, desc)
          begin()
          if (e == r) then
            return pass()
          else
            return fail(desc, "Expected '", a["pr-str"](e), "' but received '", a["pr-str"](r), "'")
          end
        end
        local function _10_(r, desc)
          begin()
          if r then
            return pass()
          else
            return fail(desc, "Expected truthy result but received '", a["pr-str"](r), "'")
          end
        end
        local function _11_(e, r, desc)
          begin()
          local se = a["pr-str"](e)
          local sr = a["pr-str"](r)
          if (se == sr) then
            return pass()
          else
            return fail(desc, "Expected (with pr) '", se, "' but received '", sr, "'")
          end
        end
        t = {["="] = _9_, ["ok?"] = _10_, ["pr="] = _11_}
        local _12_, _13_ = nil, nil
        local function _14_()
          return f(t)
        end
        _12_, _13_ = pcall(_14_)
        if ((_12_ == false) and (nil ~= _13_)) then
          local err = _13_
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
run = _5_
_2amodule_2a["run"] = run
_2amodule_2a["aniseed/locals"]["run"] = run
local run_all
local function _6_()
  local function _7_(totals, results)
    for k, v in pairs(results) do
      totals[k] = (v + totals[k])
    end
    return totals
  end
  return display_results(a.reduce(_7_, {["assertions-passed"] = 0, ["tests-passed"] = 0, assertions = 0, tests = 0}, a.filter(a["table?"], a.map(run, a.keys(package.loaded)))), "[total]")
end
run_all = _6_
_2amodule_2a["run-all"] = run_all
_2amodule_2a["aniseed/locals"]["run-all"] = run_all
local suite
local function _7_()
  do
    local sep = fs["path-sep"]
    local function _8_(path)
      return require(string.gsub(string.match(path, ("^test" .. sep .. "fnl" .. sep .. "(.-).fnl$")), sep, "."))
    end
    a["run!"](_8_, nvim.fn.globpath(("test" .. sep .. "fnl"), "**/*-test.fnl", false, true))
  end
  if ok_3f(run_all()) then
    return nvim.ex.q()
  else
    return nvim.ex.cq()
  end
end
suite = _7_
_2amodule_2a["suite"] = suite
_2amodule_2a["aniseed/locals"]["suite"] = suite
return nil
