local core = require("aniseed.core")
local fs = require("aniseed.fs")
local nvim = require("aniseed.nvim")
local fennel = require("aniseed.fennel")
local function file(src, dest)
  local content = core.slurp(src)
  local ok, val = ok, val
  local function _0_()
    return fennel.compileString(content, {filename = src})
  end
  ok, val = xpcall(_0_, fennel.traceback)
  if ok then
    fs["ensure-ancestor-dirs"](dest)
    return core.spit(dest, val)
  else
    return io.stderr.write(val)
  end
end
local function glob(src_expr, src_dir, dest_dir)
  local src_dir_len = core.inc(string.len(src_dir))
  local src_paths = nil
  local function _0_(path)
    return string.sub(path, src_dir_len)
  end
  src_paths = core.map(_0_, nvim.fn.globpath(src_dir, src_expr, true, true))
  for _, path in ipairs(src_paths) do
    file((src_dir .. path), string.gsub((dest_dir .. path), ".fnl$", ".lua"))
  end
  return nil
end
return {file = file, glob = glob}
