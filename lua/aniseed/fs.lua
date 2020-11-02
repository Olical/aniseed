local _0_0 = nil
do
  local _2_0 = "aniseed.fs"
  local _1_0 = {}
  package.loaded[_2_0] = _1_0
  _0_0 = _1_0
end
local _3_ = {require("aniseed.nvim")}
local nvim = _3_[1]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "aniseed.fs"
do local _ = ({nil, _0_0, {{}, nil, nil, nil}})[2] end
local basename = nil
do
  local v_0_ = nil
  local function basename0(path)
    return nvim.fn.fnamemodify(path, ":h")
  end
  v_0_ = basename0
  _0_0["basename"] = v_0_
  basename = v_0_
end
local mkdirp = nil
do
  local v_0_ = nil
  local function mkdirp0(dir)
    return nvim.fn.mkdir(dir, "p")
  end
  v_0_ = mkdirp0
  _0_0["mkdirp"] = v_0_
  mkdirp = v_0_
end
return nil
