local _2amodule_2a, _2amodule_name_2a, _2afile_2a = nil, nil, nil
local _0_
do
  local mod_0_ = {["aniseed/local-fns"] = {}, ["aniseed/locals"] = {}, ["aniseed/module"] = "aniseed.autoload"}
  package.loaded["aniseed.autoload"] = mod_0_
  _0_ = mod_0_
end
_2amodule_2a, _2amodule_name_2a, _2afile_2a = _0_, "aniseed.autoload", "fnl/aniseed/autoload.fnl"
local autoload
local function _1_(alias, name)
  local function ensure()
    alias = require(name)
    return alias
  end
  local function _2_(t, ...)
    return ensure()(...)
  end
  local function _3_(t, k)
    return ensure()[k]
  end
  local function _4_(t, k, v)
    ensure()[k] = v
    return nil
  end
  return setmetatable({}, {__call = _2_, __index = _3_, __newindex = _4_})
end
autoload = _1_
_2amodule_2a["autoload"] = autoload
_2amodule_2a["aniseed/locals"]["autoload"] = autoload
return nil
