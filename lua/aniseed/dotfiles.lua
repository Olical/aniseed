local _0_0
do
  local module_0_ = {}
  package.loaded["aniseed.dotfiles"] = module_0_
  _0_0 = module_0_
end
local _local_0_ = {require("aniseed.compile"), require("aniseed.fennel"), require("aniseed.nvim")}
local compile = _local_0_[1]
local fennel = _local_0_[2]
local nvim = _local_0_[3]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "aniseed.dotfiles"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
nvim.out_write("Warning: aniseed.dotfiles is deprecated, see :help aniseed-dotfiles\n")
local config_dir = nvim.fn.stdpath("config")
fennel["add-path"]((config_dir .. "/?.fnl"))
compile.glob("**/*.fnl", (config_dir .. "/fnl"), (config_dir .. "/lua"))
return require("dotfiles.init")
