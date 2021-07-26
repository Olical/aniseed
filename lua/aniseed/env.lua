local autoload
local function _0_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _0_
local compile, fennel, fs, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil, nil, nil, nil
local _1_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {compile = "aniseed.compile", fennel = "aniseed.fennel", fs = "aniseed.fs", nvim = "aniseed.nvim"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.env"}
  package.loaded["aniseed.env"] = mod_0_
  _1_ = mod_0_
end
compile, fennel, fs, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(compile, "aniseed.compile"), autoload(fennel, "aniseed.fennel"), autoload(fs, "aniseed.fs"), autoload(nvim, "aniseed.nvim"), _1_, "aniseed.env", "fnl/aniseed/env.fnl"
local config_dir = nvim.fn.stdpath("config")
do end (_2amodule_2a)["aniseed/locals"]["config-dir"] = config_dir
local quiet_require
local function _2_(m)
  local ok_3f, err = nil, nil
  local function _3_()
    return require(m)
  end
  ok_3f, err = pcall(_3_)
  if (not ok_3f and not err:find(("module '" .. m .. "' not found"))) then
    return nvim.ex.echoerr(err)
  end
end
quiet_require = _2_
_2amodule_2a["aniseed/locals"]["quiet-require"] = quiet_require
local init
local function _3_(opts)
  local opts0
  if ("table" == type(opts)) then
    opts0 = opts
  else
    opts0 = {}
  end
  local glob_expr = "**/*.fnl"
  local fnl_dir = (opts0.input or (config_dir .. fs["path-sep"] .. "fnl"))
  local lua_dir = (opts0.output or (config_dir .. fs["path-sep"] .. "lua"))
  package.path = (package.path .. ";" .. lua_dir .. fs["path-sep"] .. "?.lua")
  local function _5_(path)
    if fs["macro-file-path?"](path) then
      return path
    else
      return string.gsub(path, ".fnl$", ".lua")
    end
  end
  if (((false ~= opts0.compile) or os.getenv("ANISEED_ENV_COMPILE")) and fs["glob-dir-newer?"](fnl_dir, lua_dir, glob_expr, _5_)) then
    fennel["add-path"]((fnl_dir .. fs["path-sep"] .. "?.fnl"))
    compile.glob(glob_expr, fnl_dir, lua_dir, opts0)
  end
  return quiet_require((opts0.module or "init"))
end
init = _3_
_2amodule_2a["init"] = init
_2amodule_2a["aniseed/locals"]["init"] = init
return nil
