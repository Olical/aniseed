local _0_0 = nil
do
  local name_23_0_ = "aniseed.eval"
  local loaded_23_0_ = package.loaded[name_23_0_]
  local module_23_0_ = nil
  if ("table" == type(loaded_23_0_)) then
    module_23_0_ = loaded_23_0_
  else
    module_23_0_ = {}
  end
  module_23_0_["aniseed/module"] = name_23_0_
  module_23_0_["aniseed/locals"] = (module_23_0_["aniseed/locals"] or {})
  module_23_0_["aniseed/local-fns"] = (module_23_0_["aniseed/local-fns"] or {})
  package.loaded[name_23_0_] = module_23_0_
  _0_0 = module_23_0_
end
local function _1_(...)
  _0_0["aniseed/local-fns"] = {require = {compile = "aniseed.compile", core = "aniseed.core", fennel = "aniseed.fennel", fs = "aniseed.fs", nvim = "aniseed.nvim"}}
  return {require("aniseed.nvim"), require("aniseed.core"), require("aniseed.compile"), require("aniseed.fennel"), require("aniseed.fs")}
end
local _2_ = _1_(...)
local nvim = _2_[1]
local core = _2_[2]
local compile = _2_[3]
local fennel = _2_[4]
local fs = _2_[5]
do local _ = ({nil, _0_0, nil})[2] end
local str = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function str0(code, opts)
      local function _3_()
        return fennel.eval(compile["macros-prefix"](code), opts)
      end
      return xpcall(_3_, fennel.traceback)
    end
    v_23_0_0 = str0
    _0_0["str"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["str"] = v_23_0_
  str = v_23_0_
end
return nil
