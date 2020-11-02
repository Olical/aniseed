local _0_0 = nil
do
  local _2_0 = "aniseed.compile"
  local _1_0 = {}
  package.loaded[_2_0] = _1_0
  _0_0 = _1_0
end
local _3_ = {require("aniseed.core"), require("aniseed.fennel"), require("aniseed.fs"), require("aniseed.nvim")}
local a = _3_[1]
local fennel = _3_[2]
local fs = _3_[3]
local nvim = _3_[4]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "aniseed.compile"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
do
  local fnl_suffixes = string.gsub(string.gsub(package.path, "%.lua;", ".fnl;"), "%.lua$", ".fnl")
  fennel.path = (string.gsub(fnl_suffixes, "/lua/", "/fnl/") .. ";" .. fnl_suffixes)
end
local add_path = nil
do
  local v_0_ = nil
  local function add_path0(path)
    fennel.path = (fennel.path .. ";" .. path)
    return nil
  end
  v_0_ = add_path0
  _0_0["add-path"] = v_0_
  add_path = v_0_
end
local macros_prefix = nil
do
  local v_0_ = nil
  local function macros_prefix0(code)
    local macros_module = "aniseed.macros"
    return ("(require-macros \"" .. macros_module .. "\")\n" .. code)
  end
  v_0_ = macros_prefix0
  _0_0["macros-prefix"] = v_0_
  macros_prefix = v_0_
end
local str = nil
do
  local v_0_ = nil
  local function str0(code, opts)
    local function _4_()
      return fennel.compileString(macros_prefix(code), a.merge({["compiler-env"] = _G}, opts))
    end
    return xpcall(_4_, fennel.traceback)
  end
  v_0_ = str0
  _0_0["str"] = v_0_
  str = v_0_
end
local file = nil
do
  local v_0_ = nil
  local function file0(src, dest, opts)
    if ((a["table?"](opts) and opts.force) or (nvim.fn.getftime(src) > nvim.fn.getftime(dest))) then
      local code = a.slurp(src)
      local _4_0, _5_0 = str(code, {filename = src})
      if ((_4_0 == false) and (nil ~= _5_0)) then
        local err = _5_0
        return nvim.err_writeln(err)
      elseif ((_4_0 == true) and (nil ~= _5_0)) then
        local result = _5_0
        fs.mkdirp(fs.basename(dest))
        return a.spit(dest, result)
      end
    end
  end
  v_0_ = file0
  _0_0["file"] = v_0_
  file = v_0_
end
local glob = nil
do
  local v_0_ = nil
  local function glob0(src_expr, src_dir, dest_dir, opts)
    local src_dir_len = a.inc(string.len(src_dir))
    local src_paths = nil
    local function _4_(path)
      return string.sub(path, src_dir_len)
    end
    src_paths = a.map(_4_, nvim.fn.globpath(src_dir, src_expr, true, true))
    for _, path in ipairs(src_paths) do
      if (a.get(opts, "include-macros-suffix?") or not string.match(path, "macros.fnl$")) then
        file((src_dir .. path), string.gsub((dest_dir .. path), ".fnl$", ".lua"), opts)
      end
    end
    return nil
  end
  v_0_ = glob0
  _0_0["glob"] = v_0_
  glob = v_0_
end
return nil
