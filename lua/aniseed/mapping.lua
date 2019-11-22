local core = require("aniseed.core")
local str = require("aniseed.string")
local nvim = require("aniseed.nvim")
local nu = require("aniseed.nvim.util")
local fennel = require("aniseed.fennel")
local function handle_result(x)
  if (core["table?"](x) and x["aniseed/module"]) then
    package.loaded[x["aniseed/module"]] = x
  end
  local function _1_()
    return core.pr(x)
  end
  return vim.schedule(_1_)
end
local function selection(type, ...)
  local sel_backup = nvim.o.selection
  local _0_ = {...}
  local visual_3f = _0_[1]
  nvim.ex.let("g:aniseed_reg_backup = @@")
  nvim.o.selection = "inclusive"
  if visual_3f then
    nu.normal(("`<" .. type .. "`>y"))
  elseif (type == "line") then
    nu.normal("'[V']y")
  elseif (type == "block") then
    nu.normal("`[\22`]y")
  else
    nu.normal("`[v`]y")
  end
  do
    local selection = nvim.eval("@@")
    nvim.o.selection = sel_backup
    nvim.ex.let("@@ = g:aniseed_reg_backup")
    return selection
  end
end
local function eval(code)
  return handle_result(fennel.eval(code))
end
local function eval_selection(...)
  return eval(selection(...))
end
local function eval_range(first_line, last_line)
  return eval(str.join("\n", nvim.fn.getline(first_line, last_line)))
end
local function eval_file(path)
  return handle_result(fennel.dofile(path))
end
local function init()
  nu["fn-bridge"]("AniseedSelection", "aniseed.mapping", "selection")
  nu["fn-bridge"]("AniseedEval", "aniseed.mapping", "eval")
  nu["fn-bridge"]("AniseedEvalFile", "aniseed.mapping", "eval-file")
  nu["fn-bridge"]("AniseedEvalRange", "aniseed.mapping", "eval-range", {range = true})
  nu["fn-bridge"]("AniseedEvalSelection", "aniseed.mapping", "eval-selection")
  nvim.ex.command_("-nargs=1", "AniseedEval", "call AniseedEval(<q-args>)")
  nvim.ex.command_("-nargs=1", "AniseedEvalFile", "call AniseedEvalFile(<q-args>)")
  nvim.ex.command_("-range", "AniseedEvalRange", "<line1>,<line2>call AniseedEvalRange()")
  nvim.set_keymap("n", "<Plug>(AniseedEval)", ":set opfunc=AniseedEvalSelection<cr>g@", {noremap = true, silent = true})
  nvim.set_keymap("n", "<Plug>(AniseedEvalCurrentFile)", ":call AniseedEvalFile(expand('%'))<cr>", {noremap = true, silent = true})
  return nvim.set_keymap("v", "<Plug>(AniseedEvalSelection)", ":<c-u>call AniseedEvalSelection(visualmode(), v:true)<cr>", {noremap = true, silent = true})
end
return {["aniseed/module"] = "aniseed.mapping", ["eval-file"] = eval_file, ["eval-range"] = eval_range, ["eval-selection"] = eval_selection, eval = eval, init = init, selection = selection}
