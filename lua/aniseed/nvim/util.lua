local autoload = (require("aniseed.autoload")).autoload
local nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil, nil
local _0_
do
  local mod_0_ = {["aniseed/local-fns"] = {autoload = {nvim = "aniseed.nvim"}}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.nvim.util"}
  package.loaded["aniseed.nvim.util"] = mod_0_
  _0_ = mod_0_
end
nvim, _2amodule_2a, _2amodule_name_2a, _2afile_2a = autoload(nvim, "aniseed.nvim"), _0_, "aniseed.nvim.util", "fnl/aniseed/nvim/util.fnl"
local normal
local function _1_(keys)
  return nvim.ex.silent(("exe \"normal! " .. keys .. "\""))
end
normal = _1_
_2amodule_2a["normal"] = normal
_2amodule_2a["aniseed/locals"]["normal"] = normal
local fn_bridge
local function _2_(viml_name, mod, lua_name, opts)
  local _let_0_ = (opts or {})
  local range = _let_0_["range"]
  local _return = _let_0_["return"]
  local _3_
  if range then
    _3_ = " range"
  else
    _3_ = ""
  end
  local _5_
  if (_return ~= false) then
    _5_ = "return"
  else
    _5_ = "call"
  end
  local _7_
  if range then
    _7_ = "\" . a:firstline . \", \" . a:lastline . \", "
  else
    _7_ = ""
  end
  return nvim.ex.function_((viml_name .. "(...)" .. _3_ .. "\n          " .. _5_ .. " luaeval(\"require('" .. mod .. "')['" .. lua_name .. "'](" .. _7_ .. "unpack(_A))\", a:000)\n          endfunction"))
end
fn_bridge = _2_
_2amodule_2a["fn-bridge"] = fn_bridge
_2amodule_2a["aniseed/locals"]["fn-bridge"] = fn_bridge
local with_out_str
local function _3_(f)
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
with_out_str = _3_
_2amodule_2a["with-out-str"] = with_out_str
_2amodule_2a["aniseed/locals"]["with-out-str"] = with_out_str
return nil
