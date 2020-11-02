local _0_0 = nil
do
  local _2_0 = "aniseed.fennel"
  local _1_0 = require("aniseed.deps.fennel")
  package.loaded[_2_0] = _1_0
  _0_0 = _1_0
end
local _3_ = {require("aniseed.deps.fennel"), require("aniseed.nvim")}
local fennel = _3_[1]
local nvim = _3_[2]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "aniseed.fennel"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
nvim.ex.let("&runtimepath = &runtimepath")
fennel["path"] = string.gsub(string.gsub(string.gsub(package.path, "/lua/", "/fnl/"), ".lua;", ".fnl;"), ".lua$", ".fnl")
return nil
