local nvim = require("aniseed.nvim")
local view = require("aniseed.view")
local fennel = require("aniseed.fennel")
local function eval(type, ...)
  local sel_backup = nvim.o.selection
  local _0_ = {...}
  local visual_3f = _0_[1]
  local normal = normal
  local function _1_(...)
    return nvim.ex.silent(("exe \"normal! " .. ... .. "\""))
  end
  normal = _1_
  nvim.ex.let("g:aniseed_reg_backup = @@")
  nvim.o.selection = "inclusive"
  if visual_3f then
    normal("`<", type, "`>y")
  elseif (type == "line") then
    normal("'[V']y")
  elseif (type == "block") then
    normal("`[<c-v>`]y")
  else
    normal("`[v`]y")
  end
  do
    local result = fennel.eval(nvim.eval("@@"))
    nvim.o.selection = sel_backup
    nvim.ex.let("@@ = g:aniseed_reg_backup")
    local function _3_()
      return print(view(result))
    end
    vim.schedule(_3_)
    return result
  end
end
local function init()
  nvim.ex.function_("AniseedEval(...)\n    return luaeval(\"require('aniseed/mappings').eval(unpack(_A))\", a:000)\n    endfunction")
  nvim.set_keymap("n", "<Plug>(AniseedEval)", ":set opfunc=AniseedEval<cr>g@", {noremap = true, silent = true})
  return nvim.set_keymap("v", "<Plug>(AniseedEvalSelection)", ":<c-u>call AniseedEval(visualmode(), v:true)<cr>", {noremap = true, silent = true})
end
return {eval = eval, init = init}
