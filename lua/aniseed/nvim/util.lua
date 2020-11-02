local _0_0 = nil
do
  local _2_0 = "aniseed.nvim.util"
  local _1_0 = {}
  package.loaded[_2_0] = _1_0
  _0_0 = _1_0
end
local _3_ = {require("aniseed.nvim")}
local nvim = _3_[1]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "aniseed.nvim.util"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local normal = nil
do
  local v_0_ = nil
  local function normal0(keys)
    return nvim.ex.silent(("exe \"normal! " .. keys .. "\""))
  end
  v_0_ = normal0
  _0_0["normal"] = v_0_
  normal = v_0_
end
local fn_bridge = nil
do
  local v_0_ = nil
  local function fn_bridge0(viml_name, mod, lua_name, opts)
    local _4_ = (opts or {})
    local range = _4_["range"]
    local _return = _4_["return"]
    local function _5_()
      if range then
        return " range"
      else
        return ""
      end
    end
    local function _6_()
      if (_return ~= false) then
        return "return"
      else
        return "call"
      end
    end
    local function _7_()
      if range then
        return "\" . a:firstline . \", \" . a:lastline . \", "
      else
        return ""
      end
    end
    return nvim.ex.function_((viml_name .. "(...)" .. _5_() .. "\n          " .. _6_() .. " luaeval(\"require('" .. mod .. "')['" .. lua_name .. "'](" .. _7_() .. "unpack(_A))\", a:000)\n          endfunction"))
  end
  v_0_ = fn_bridge0
  _0_0["fn-bridge"] = v_0_
  fn_bridge = v_0_
end
local with_out_str = nil
do
  local v_0_ = nil
  local function with_out_str0(f)
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
  v_0_ = with_out_str0
  _0_0["with-out-str"] = v_0_
  with_out_str = v_0_
end
return nil
