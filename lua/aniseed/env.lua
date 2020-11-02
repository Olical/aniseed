local _0_0 = nil
do
  local _2_0 = "aniseed.env"
  local _1_0 = {}
  package.loaded[_2_0] = _1_0
  _0_0 = _1_0
end
local _3_ = {require("aniseed.core"), require("aniseed.compile"), require("aniseed.nvim")}
local a = _3_[1]
local compile = _3_[2]
local nvim = _3_[3]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "aniseed.env"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local config_dir = nvim.fn.stdpath("config")
compile["add-path"]((config_dir .. "/?.fnl"))
local init = nil
do
  local v_0_ = nil
  local function init0(opts)
    compile.glob("**/*.fnl", (config_dir .. a.get(opts, "input", "/fnl")), (config_dir .. a.get(opts, "output", "/lua")))
    return require(a.get(opts, "module", "init"))
  end
  v_0_ = init0
  _0_0["init"] = v_0_
  init = v_0_
end
return nil
