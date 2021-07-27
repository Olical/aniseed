local autoload = (require("aniseed.autoload")).autoload
local nvim, fs, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil, nil
local _0_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {fs = "aniseed.fs", nvim = "aniseed.nvim"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.fennel"}
  package.loaded["aniseed.fennel"] = mod_0_
  _0_ = mod_0_
end
nvim, fs, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(nvim, "aniseed.nvim"), autoload(fs, "aniseed.fs"), _0_, "aniseed.fennel", "fnl/aniseed/fennel.fnl"
local sync_rtp
local function _1_(compiler)
  local sep = fs["path-sep"]
  local fnl_suffix = (sep .. "fnl" .. sep .. "?.fnl")
  local rtp = nvim.o.runtimepath
  local fnl_path = (rtp:gsub(",", (fnl_suffix .. ";")) .. fnl_suffix)
  local lua_path = fnl_path:gsub((sep .. "fnl" .. sep), (sep .. "lua" .. sep))
  do end (compiler)["path"] = (fnl_path .. ";" .. lua_path)
  return nil
end
sync_rtp = _1_
_2amodule_2a["sync-rtp"] = sync_rtp
_2amodule_2a["aniseed/locals"]["sync-rtp"] = sync_rtp
local state = {["compiler-loaded?"] = false}
_2amodule_2a["aniseed/locals"]["state"] = state
local impl
local function _2_()
  local compiler = require("aniseed.deps.fennel")
  if not state["compiler-loaded?"] then
    state["compiler-loaded?"] = true
    sync_rtp(compiler)
  end
  return compiler
end
impl = _2_
_2amodule_2a["impl"] = impl
_2amodule_2a["aniseed/locals"]["impl"] = impl
local add_path
local function _3_(path)
  local fnl = impl()
  do end (fnl)["path"] = (fnl.path .. ";" .. path)
  return nil
end
add_path = _3_
_2amodule_2a["add-path"] = add_path
_2amodule_2a["aniseed/locals"]["add-path"] = add_path
return nil
