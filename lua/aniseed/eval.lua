local autoload = (require("aniseed.autoload")).autoload
local a, compile, fs, fennel, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil, nil, nil, nil, nil
local _0_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {a = "aniseed.core", compile = "aniseed.compile", fennel = "aniseed.fennel", fs = "aniseed.fs", nvim = "aniseed.nvim"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.eval"}
  package.loaded["aniseed.eval"] = mod_0_
  _0_ = mod_0_
end
a, compile, fs, fennel, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(a, "aniseed.core"), autoload(compile, "aniseed.compile"), autoload(fs, "aniseed.fs"), autoload(fennel, "aniseed.fennel"), autoload(nvim, "aniseed.nvim"), _0_, "aniseed.eval", "fnl/aniseed/eval.fnl"
local base_path
do
  local _1_ = (debug.getinfo(1, "S")).source
  if _1_ then
    local _2_ = _1_:gsub("^.", "")
    if _2_ then
      base_path = _2_:gsub(string.gsub(_2afile_2a, "fnl", "lua"), "")
    else
      base_path = _2_
    end
  else
    base_path = _1_
  end
end
local str = nil
local function _2_(code, opts)
  local fnl = fennel.impl()
  local plugins = {"module-system-plugin.fnl"}
  local plugins0
  do
    local tbl_0_ = {}
    for _, plugin in ipairs(plugins) do
      tbl_0_[(#tbl_0_ + 1)] = fnl.dofile((base_path .. plugin), {env = "_COMPILER", useMetadata = true})
    end
    plugins0 = tbl_0_
  end
  local function _3_()
    return fnl.eval(code, a.merge({["compiler-env"] = _G, plugins = plugins0}, opts))
  end
  return xpcall(_3_, fnl.traceback)
end
str = _2_
_2amodule_2a["str"] = str
_2amodule_2a["aniseed/locals"]["str"] = str
return nil
