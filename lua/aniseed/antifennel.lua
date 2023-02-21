local _2afile_2a = "fnl/aniseed/antifennel.fnl"
local _2amodule_name_2a = "aniseed.antifennel"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local autoload = (require("aniseed.autoload")).autoload
local a, antifnl, compile, str = autoload("aniseed.core"), autoload("aniseed.deps.antifennel"), autoload("aniseed.compile"), autoload("aniseed.string")
do end (_2amodule_locals_2a)["a"] = a
_2amodule_locals_2a["antifnl"] = antifnl
_2amodule_locals_2a["compile"] = compile
_2amodule_locals_2a["str"] = str
local function get_popup_size(hr, wr)
  local screen_w = vim.o.columns
  local screen_h = (vim.o.lines - vim.o.cmdheight)
  local window_w = math.floor((screen_w * wr))
  local window_h = math.floor((screen_h * hr))
  local center_x = ((screen_w - window_w) / 2)
  local center_y = ((screen_h - window_h) / 2)
  return {col = center_x, row = (center_y - vim.o.cmdheight), height = window_h, width = window_w}
end
_2amodule_locals_2a["get_popup_size"] = get_popup_size
local function fnl_antilua()
  if (vim.o.filetype == "fennel") then
    local _, result = compile.str(str.join("\n", vim.api.nvim_buf_get_lines(0, 0, -1, true)), {})
    local content = str.split(result, "\n")
    local win_opts = a["merge!"]({relative = "editor", border = "double"}, get_popup_size(0.8, 0.6))
    local map_opts = {noremap = true, silent = true}
    local bufnr = vim.api.nvim_create_buf(false, false)
    local winnr = vim.api.nvim_open_win(bufnr, 0, win_opts)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
    vim.api.nvim_buf_set_option(bufnr, "filetype", "lua")
    vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":bdelete<CR>", map_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<ESC>", ":bdelete<CR>", map_opts)
    return vim.api.nvim_win_set_option(winnr, "winhl", "Normal:NormalFloat")
  else
    return nil
  end
end
_2amodule_2a["fnl_antilua"] = fnl_antilua
local function lua_antifennel()
  if (vim.o.filetype == "lua") then
    local _, result = pcall(antifnl, str.join("\n", vim.api.nvim_buf_get_lines(0, 0, -1, true)))
    local content = str.split(result, "\n")
    local win_opts = a["merge!"]({relative = "editor", border = "double"}, get_popup_size(0.8, 0.6))
    local map_opts = {noremap = true, silent = true}
    local bufnr = vim.api.nvim_create_buf(false, false)
    local winnr = vim.api.nvim_open_win(bufnr, 0, win_opts)
    vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, content)
    vim.api.nvim_buf_set_option(bufnr, "filetype", "fennel")
    vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
    vim.api.nvim_buf_set_keymap(bufnr, "n", "q", ":bdelete<CR>", map_opts)
    vim.api.nvim_buf_set_keymap(bufnr, "n", "<ESC>", ":bdelete<CR>", map_opts)
    return vim.api.nvim_win_set_option(winnr, "winhl", "Normal:NormalFloat")
  else
    return nil
  end
end
_2amodule_2a["lua_antifennel"] = lua_antifennel
return _2amodule_2a