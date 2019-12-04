local nvim = require("aniseed.nvim")
local function basename(path)
  return nvim.fn.fnamemodify(path, ":h")
end
local function mkdirp(dir)
  return nvim.fn.mkdir(dir, "p")
end
return {["aniseed/module"] = "aniseed.fs", basename = basename, mkdirp = mkdirp}
