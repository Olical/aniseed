local _2afile_2a = "fnl/aniseed/setup.fnl"
local _2amodule_name_2a = "aniseed.setup"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("aniseed.autoload")).autoload
local env, nvim = autoload("aniseed.env"), autoload("aniseed.nvim")
do end (_2amodule_locals_2a)["env"] = env
_2amodule_locals_2a["nvim"] = nvim
local function init()
  if nvim.g["aniseed#env"] then
    return env.init(nvim.g["aniseed#env"])
  else
    return nil
  end
end
_2amodule_2a["init"] = init
return _2amodule_2a
