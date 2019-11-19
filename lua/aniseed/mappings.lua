local nvim = require("aniseed.nvim")
local view = require("aniseed.view")
local fennel = require("aniseed.fennel")
local function normal(keys)
  return nvim.ex.silent(("exe \"normal! " .. keys .. "\""))
end
local function def_viml_bridge_function(viml_name, lua_name)
  return nvim.ex.function_((viml_name .. "(...)\n              call luaeval(\"require('aniseed/mappings')['" .. lua_name .. "'](unpack(_A))\", a:000)\n              endfunction"))
end
local function selection(type, ...)
  local sel_backup = nvim.o.selection
  local _0_ = {...}
  local visual_3f = _0_[1]
  nvim.ex.let("g:aniseed_reg_backup = @@")
  nvim.o.selection = "inclusive"
  if visual_3f then
    normal(("`<" .. type .. "`>y"))
  elseif (type == "line") then
    normal("'[V']y")
  elseif (type == "block") then
    normal("`[\22`]y")
  else
    normal("`[v`]y")
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
local function init()
  def_viml_bridge_function("AniseedSelection", "selection")
  def_viml_bridge_function("AniseedEval", "eval")
  def_viml_bridge_function("AniseedEvalSelection", "eval-selection")
  nvim.ex.command_("-nargs=1", "AniseedEval", "call AniseedEval(<q-args>)")
  nvim.set_keymap("n", "<Plug>(AniseedEval)", ":set opfunc=AniseedEvalSelection<cr>g@", {noremap = true, silent = true})
  return nvim.set_keymap("v", "<Plug>(AniseedEvalSelection)", ":<c-u>call AniseedEvalSelection(visualmode(), v:true)<cr>", {noremap = true, silent = true})
end
return {["eval-selection"] = eval_selection, eval = eval, init = init, selection = selection}
