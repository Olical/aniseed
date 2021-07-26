local autoload
local function _0_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _0_
local nvim, fennel, fs, a, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil, nil, nil, nil
local _1_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {a = "aniseed.core", fennel = "aniseed.fennel", fs = "aniseed.fs", nvim = "aniseed.nvim"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.compile"}
  package.loaded["aniseed.compile"] = mod_0_
  _1_ = mod_0_
end
nvim, fennel, fs, a, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(nvim, "aniseed.nvim"), autoload(fennel, "aniseed.fennel"), autoload(fs, "aniseed.fs"), autoload(a, "aniseed.core"), _1_, "aniseed.compile", "fnl/aniseed/compile.fnl"
local base_path
do
  local _2_ = (debug.getinfo(1, "S")).source
  if _2_ then
    local _3_ = _2_:gsub("^.", "")
    if _3_ then
      base_path = _3_:gsub(string.gsub(_2afile_2a, "fnl", "lua"), "")
    else
      base_path = _3_
    end
  else
    base_path = _2_
  end
end
local str
local function _3_(code, opts)
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
  local function _4_()
    return fnl.compileString(code, a.merge({allowedGlobals = false, plugins = plugins0}, opts))
  end
  return xpcall(_4_, fnl.traceback)
end
str = _3_
_2amodule_2a["str"] = str
_2amodule_2a["aniseed/locals"]["str"] = str
local file
local function _4_(src, dest)
  local code = a.slurp(src)
  local _5_, _6_ = str(code, {filename = src})
  if ((_5_ == false) and (nil ~= _6_)) then
    local err = _6_
    return nvim.err_writeln(err)
  elseif ((_5_ == true) and (nil ~= _6_)) then
    local result = _6_
    fs.mkdirp(fs.basename(dest))
    return a.spit(dest, result)
  end
end
file = _4_
_2amodule_2a["file"] = file
_2amodule_2a["aniseed/locals"]["file"] = file
local glob
local function _5_(src_expr, src_dir, dest_dir)
  for _, path in ipairs(fs.relglob(src_dir, src_expr)) do
    if fs["macro-file-path?"](path) then
      a.spit((dest_dir .. path), a.slurp((src_dir .. path)))
    else
      file((src_dir .. path), string.gsub((dest_dir .. path), ".fnl$", ".lua"))
    end
  end
  return nil
end
glob = _5_
_2amodule_2a["glob"] = glob
_2amodule_2a["aniseed/locals"]["glob"] = glob
return nil
