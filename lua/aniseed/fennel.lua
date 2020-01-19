local nvim = require("aniseed.nvim")
local fennel = require("aniseed.deps.fennel")
nvim.ex.let("&runtimepath = &runtimepath")
fennel["path"] = string.gsub(string.gsub(string.gsub(package.path, "/lua/", "/fnl/"), ".lua;", ".fnl;"), ".lua$", ".fnl")
fennel["aniseed/module"] = "aniseed.fennel"
return fennel
