local nvim = require("aniseed.nvim")
local function ensure_parent_dirs(path)
  local parent = nvim["call-function"]("fnamemodify", path, ":h")
  return nvim["call-function"]("mkdir", parent, "p")
end
return {["ensure-parent-dirs"] = ensure_parent_dirs}
