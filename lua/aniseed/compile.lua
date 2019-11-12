local core = require("aniseed.core")
local fs = require("aniseed.fs")
local nvim = require("aniseed.nvim")
local fennel = require("aniseed.fennel")
local function code_string(content, opts)
  local function _0_()
    return fennel.compileString(content, opts)
  end
  return xpcall(_0_, fennel.traceback)
end
local function file(src, dest, opts)
  if (opts.force or (nvim.fn.getftime(src) > nvim.fn.getftime(dest))) then
    local content = core.slurp(src)
    do
      local _0_0, _1_0 = code_string(content, {filename = src})
      if ((_0_0 == false) and (nil ~= _1_0)) then
        local err = _1_0
        return io.stderr.write(err)
      elseif ((_0_0 == true) and (nil ~= _1_0)) then
        local result = _1_0
        do
          fs["ensure-ancestor-dirs"](dest)
          return core.spit(dest, result)
        end
      end
    end
  end
end
local function glob(src_expr, src_dir, dest_dir, opts)
  local src_dir_len = core.inc(string.len(src_dir))
  local src_paths = nil
  local function _0_(path)
    return string.sub(path, src_dir_len)
  end
  src_paths = core.map(_0_, nvim.fn.globpath(src_dir, src_expr, true, true))
  for _, path in ipairs(src_paths) do
    file((src_dir .. path), string.gsub((dest_dir .. path), ".fnl$", ".lua"), opts)
  end
  return nil
end
return {["code-string"] = code_string, file = file, glob = glob}
