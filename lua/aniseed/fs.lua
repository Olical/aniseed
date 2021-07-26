local autoload
local function _0_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _0_
local a, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil, nil
local _1_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {a = "aniseed.core", nvim = "aniseed.nvim"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.fs"}
  package.loaded["aniseed.fs"] = mod_0_
  _1_ = mod_0_
end
a, nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(a, "aniseed.core"), autoload(nvim, "aniseed.nvim"), _1_, "aniseed.fs", "fnl/aniseed/fs.fnl"
local path_sep
do
  local os = string.lower(jit.os)
  if (("linux" == os) or ("osx" == os) or ("bsd" == os)) then
    path_sep = "/"
  else
    path_sep = "\\"
  end
end
_2amodule_2a["path-sep"] = path_sep
_2amodule_2a["aniseed/locals"]["path-sep"] = path_sep
local basename
local function _2_(path)
  return nvim.fn.fnamemodify(path, ":h")
end
basename = _2_
_2amodule_2a["basename"] = basename
_2amodule_2a["aniseed/locals"]["basename"] = basename
local mkdirp
local function _3_(dir)
  return nvim.fn.mkdir(dir, "p")
end
mkdirp = _3_
_2amodule_2a["mkdirp"] = mkdirp
_2amodule_2a["aniseed/locals"]["mkdirp"] = mkdirp
local relglob
local function _4_(dir, expr)
  local dir_len = a.inc(string.len(dir))
  local function _5_(_241)
    return string.sub(_241, dir_len)
  end
  return a.map(_5_, nvim.fn.globpath(dir, expr, true, true))
end
relglob = _4_
_2amodule_2a["relglob"] = relglob
_2amodule_2a["aniseed/locals"]["relglob"] = relglob
local glob_dir_newer_3f
local function _5_(a_dir, b_dir, expr, b_dir_path_fn)
  local newer_3f = false
  for _, path in ipairs(relglob(a_dir, expr)) do
    if (nvim.fn.getftime((a_dir .. path)) > nvim.fn.getftime((b_dir .. b_dir_path_fn(path)))) then
      newer_3f = true
    end
  end
  return newer_3f
end
glob_dir_newer_3f = _5_
_2amodule_2a["glob-dir-newer?"] = glob_dir_newer_3f
_2amodule_2a["aniseed/locals"]["glob-dir-newer?"] = glob_dir_newer_3f
local macro_file_path_3f
local function _6_(path)
  return string.match(path, "macros.fnl$")
end
macro_file_path_3f = _6_
_2amodule_2a["macro-file-path?"] = macro_file_path_3f
_2amodule_2a["aniseed/locals"]["macro-file-path?"] = macro_file_path_3f
return nil
