local autoload
local function _0_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _0_
local nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil
local _1_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {nvim = "aniseed.nvim"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.nvim.util"}
  package.loaded["aniseed.nvim.util"] = mod_0_
  _1_ = mod_0_
end
nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(nvim, "aniseed.nvim"), _1_, "aniseed.nvim.util", "fnl/aniseed/nvim/util.fnl"
local normal
local function _2_(keys)
  return nvim.ex.silent(("exe \"normal! " .. keys .. "\""))
end
normal = _2_
_2amodule_2a["normal"] = normal
_2amodule_2a["aniseed/locals"]["normal"] = normal
local fn_bridge
local function _3_(viml_name, mod, lua_name, opts)
  local _let_0_ = (opts or {})
  local range = _let_0_["range"]
  local _return = _let_0_["return"]
  local _4_
  if range then
    _4_ = " range"
  else
    _4_ = ""
  end
  local _6_
  if (_return ~= false) then
    _6_ = "return"
  else
    _6_ = "call"
  end
  local _8_
  if range then
    _8_ = "\" . a:firstline . \", \" . a:lastline . \", "
  else
    _8_ = ""
  end
  return nvim.ex.function_((viml_name .. "(...)" .. _4_ .. "\n          " .. _6_ .. " luaeval(\"require('" .. mod .. "')['" .. lua_name .. "'](" .. _8_ .. "unpack(_A))\", a:000)\n          endfunction"))
end
fn_bridge = _3_
_2amodule_2a["fn-bridge"] = fn_bridge
_2amodule_2a["aniseed/locals"]["fn-bridge"] = fn_bridge
local with_out_str
local function _4_(f)
  nvim.ex.redir("=> g:aniseed_nvim_util_out_str")
  do
    local ok_3f, err = pcall(f)
    nvim.ex.redir("END")
    nvim.ex.echon("")
    nvim.ex.redraw()
    if not ok_3f then
      error(err)
    end
  end
  return string.gsub(nvim.g.aniseed_nvim_util_out_str, "^(\n?)(.*)$", "%2%1")
end
with_out_str = _4_
_2amodule_2a["with-out-str"] = with_out_str
_2amodule_2a["aniseed/locals"]["with-out-str"] = with_out_str
return nil
