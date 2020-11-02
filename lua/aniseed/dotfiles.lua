local _0_0 = nil
do
  local _2_0 = "aniseed.dotfiles"
  local _1_0 = {}
  package.loaded[_2_0] = _1_0
  _0_0 = _1_0
end
local _3_ = {require("aniseed.compile"), require("aniseed.nvim")}
local compile = _3_[1]
local nvim = _3_[2]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "aniseed.dotfiles"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
nvim.out_write("Warning: aniseed.dotfiles is deprecated, see :help aniseed-dotfiles\n")
local config_dir = nvim.fn.stdpath("config")
compile["add-path"]((config_dir .. "/?.fnl"))
compile.glob("**/*.fnl", (config_dir .. "/fnl"), (config_dir .. "/lua"))
return require("dotfiles.init")
