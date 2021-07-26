local autoload
local function _0_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _0_
local fs, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil, nil
local _1_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {fs = "aniseed.fs", nvim = "aniseed.nvim"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.fennel"}
  package.loaded["aniseed.fennel"] = mod_0_
  _1_ = mod_0_
end
fs, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(fs, "aniseed.fs"), autoload(nvim, "aniseed.nvim"), _1_, "aniseed.fennel", "fnl/aniseed/fennel.fnl"
local sync_rtp
local function _2_(compiler)
  local sep = fs["path-sep"]
  local fnl_suffix = (sep .. "fnl" .. sep .. "?.fnl")
  local rtp = nvim.o.runtimepath
  local fnl_path = (rtp:gsub(",", (fnl_suffix .. ";")) .. fnl_suffix)
  local lua_path = fnl_path:gsub((sep .. "fnl" .. sep), (sep .. "lua" .. sep))
  do end (compiler)["path"] = (fnl_path .. ";" .. lua_path)
  return nil
end
sync_rtp = _2_
_2amodule_2a["sync-rtp"] = sync_rtp
_2amodule_2a["aniseed/locals"]["sync-rtp"] = sync_rtp
local state = {["compiler-loaded?"] = false}
_2amodule_2a["aniseed/locals"]["state"] = state
local impl
local function _3_()
  local compiler = require("aniseed.deps.fennel")
  if not state["compiler-loaded?"] then
    state["compiler-loaded?"] = true
    sync_rtp(compiler)
  end
  return compiler
end
impl = _3_
_2amodule_2a["impl"] = impl
_2amodule_2a["aniseed/locals"]["impl"] = impl
local add_path
local function _4_(path)
  local fnl = impl()
  do end (fnl)["path"] = (fnl.path .. ";" .. path)
  return nil
end
add_path = _4_
_2amodule_2a["add-path"] = add_path
_2amodule_2a["aniseed/locals"]["add-path"] = add_path
return nil
