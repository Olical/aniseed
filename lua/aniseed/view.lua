local _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil
local _0_
do
  local mod_0_ = {["aniseed/local-fns"] = {}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.view"}
  package.loaded["aniseed.view"] = mod_0_
  _0_ = mod_0_
end
_2amodule_2a, _2amodule_name_2a, _2afile_2a = _0_, "aniseed.view", "fnl/aniseed/view.fnl"
local serialise = nil
local function _1_(...)
  return require("aniseed.deps.fennelview")(...)
end
serialise = _1_
_2amodule_2a["serialise"] = serialise
_2amodule_2a["aniseed/locals"]["serialise"] = serialise
return nil
