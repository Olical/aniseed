local core = require("aniseed.core")
local nvim = require("aniseed.nvim")
local fs = require("aniseed.fs")
local fennel = require("aniseed.fennel")
local function glob(src_dir, src_expr, dest_dir)
  local src_dir_len = core.inc(string.len(src_dir))
  local src_paths = nil
  local function _0_(path)
    return string.sub(path, src_dir_len)
  end
  src_paths = core.map(_0_, nvim["call-function"]("globpath", src_dir, src_expr, true, true))
  for _, path in ipairs(src_paths) do
    local src = (src_dir .. path)
    local dest = string.gsub((dest_dir .. path), ".fnl$", ".lua")
    local content = core.slurp(src)
    local ok, val = ok, val
    local function _1_()
      return fennel.compileString(content, {filename = src})
    end
    ok, val = xpcall(_1_, fennel.traceback)
    if ok then
      fs["ensure-parent-dirs"](dest)
      core.spit(dest, val)
    else
      io.stderr.write(val)
    end
  end
  return nil
end
return {glob = glob}
