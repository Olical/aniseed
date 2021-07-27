local autoload
local function _0_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _0_
local fennel, fs, a, compile, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil, nil, nil, nil, nil
local _1_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {a = "aniseed.core", compile = "aniseed.compile", fennel = "aniseed.fennel", fs = "aniseed.fs", nvim = "aniseed.nvim"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.eval"}
  package.loaded["aniseed.eval"] = mod_0_
  _1_ = mod_0_
end
fennel, fs, a, compile, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(fennel, "aniseed.fennel"), autoload(fs, "aniseed.fs"), autoload(a, "aniseed.core"), autoload(compile, "aniseed.compile"), autoload(nvim, "aniseed.nvim"), _1_, "aniseed.eval", "fnl/aniseed/eval.fnl"
local str
local function _2_(code, opts)
  local fnl = fennel.impl()
  local function _3_()
    return fnl.eval(compile["macros-prefix"](code, opts), a.merge({["compiler-env"] = _G}, opts))
  end
  return xpcall(_3_, fnl.traceback)
end
str = _2_
_2amodule_2a["str"] = str
_2amodule_2a["aniseed/locals"]["str"] = str
return nil
