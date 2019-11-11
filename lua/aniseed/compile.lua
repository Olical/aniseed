local core = require("aniseed.core")
local nvim = require("aniseed.nvim")
local fennel = require("aniseed.fennel")
local function glob(src_expr, dest)
  return nvim["call-function"]("glob", src_expr, true, true)
end
return {glob = glob}
