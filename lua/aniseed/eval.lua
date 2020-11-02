local _0_0 = nil
do
  local _2_0 = "aniseed.eval"
  local _1_0 = {}
  package.loaded[_2_0] = _1_0
  _0_0 = _1_0
end
local _3_ = {require("aniseed.core"), require("aniseed.compile"), require("aniseed.fennel"), require("aniseed.fs"), require("aniseed.nvim")}
local a = _3_[1]
local compile = _3_[2]
local fennel = _3_[3]
local fs = _3_[4]
local nvim = _3_[5]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "aniseed.eval"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local str = nil
do
  local v_0_ = nil
  local function str0(code, opts)
    local function _4_()
      return fennel.eval(compile["macros-prefix"](code), a.merge({["compiler-env"] = a.merge(_G, {ANISEED_DYNAMIC = true})}, opts))
    end
    return xpcall(_4_, fennel.traceback)
  end
  v_0_ = str0
  _0_0["str"] = v_0_
  str = v_0_
end
return nil
