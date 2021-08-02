local autoload = (require("aniseed.autoload")).autoload
local fennel, a, compile, fs, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil, nil, nil, nil, nil
local _0_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {a = "aniseed.core", compile = "aniseed.compile", fennel = "aniseed.fennel", fs = "aniseed.fs", nvim = "aniseed.nvim"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.eval"}
  package.loaded["aniseed.eval"] = mod_0_
  _0_ = mod_0_
end
fennel, a, compile, fs, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(fennel, "aniseed.fennel"), autoload(a, "aniseed.core"), autoload(compile, "aniseed.compile"), autoload(fs, "aniseed.fs"), autoload(nvim, "aniseed.nvim"), _0_, "aniseed.eval", "fnl/aniseed/eval.fnl"
local str = nil
local function _1_(code, opts)
  local fnl = fennel.impl()
  local function _2_()
    return fnl.eval(compile["macros-prefix"](code, opts), a.merge({["compiler-env"] = _G}, opts))
  end
  return xpcall(_2_, fnl.traceback)
end
str = _1_
_2amodule_2a["str"] = str
_2amodule_2a["aniseed/locals"]["str"] = str
return nil
