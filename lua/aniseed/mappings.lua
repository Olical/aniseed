local nvim = require("aniseed.nvim")
local nu = require("aniseed.nvim.util")
local view = require("aniseed.view")
local fennel = require("aniseed.fennel")
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
  local result = fennel.eval(code)
  local function _0_()
    return print(view(result, {["one-line"] = true}))
  end
  return vim.schedule(_0_)
end
local function eval_selection(...)
  return eval(selection(...))
end
local function eval_file(path)
  return print(view(fennel.dofile(path)))
end
local function init()
  nu["fn-bridge"]("AniseedSelection", "aniseed.mappings", "selection")
  nu["fn-bridge"]("AniseedEval", "aniseed.mappings", "eval")
  nu["fn-bridge"]("AniseedEvalFile", "aniseed.mappings", "eval-file")
  nu["fn-bridge"]("AniseedEvalSelection", "aniseed.mappings", "eval-selection")
  nvim.ex.command_("-nargs=1", "AniseedEval", "call AniseedEval(<q-args>)")
  nvim.set_keymap("n", "<Plug>(AniseedEval)", ":set opfunc=AniseedEvalSelection<cr>g@", {noremap = true, silent = true})
  nvim.set_keymap("n", "<Plug>(AniseedEvalCurrentFile)", ":call AniseedEvalFile(expand('%'))<cr>", {noremap = true, silent = true})
  return nvim.set_keymap("v", "<Plug>(AniseedEvalSelection)", ":<c-u>call AniseedEvalSelection(visualmode(), v:true)<cr>", {noremap = true, silent = true})
end
return {["eval-file"] = eval_file, ["eval-selection"] = eval_selection, eval = eval, init = init, selection = selection}
