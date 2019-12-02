-- Bring vim into local scope.
local vim = vim

-- Equivalent to `echo vim.inspect(...)`
local function nvim_print(...)
  if select("#", ...) == 1 then
    vim.api.nvim_out_write(vim.inspect((...)))
  else
    vim.api.nvim_out_write(vim.inspect {...})
  end
  vim.api.nvim_out_write("\n")
end

--- Equivalent to `echo` EX command
local function nvim_echo(...)
  for i = 1, select("#", ...) do
    local part = select(i, ...)
    vim.api.nvim_out_write(tostring(part))
    -- vim.api.nvim_out_write("\n")
    vim.api.nvim_out_write(" ")
  end
  vim.api.nvim_out_write("\n")
end

local window_options = {
            arab = true;       arabic = true;   breakindent = true; breakindentopt = true;
             bri = true;       briopt = true;            cc = true;           cocu = true;
            cole = true;  colorcolumn = true; concealcursor = true;   conceallevel = true;
             crb = true;          cuc = true;           cul = true;     cursorbind = true;
    cursorcolumn = true;   cursorline = true;          diff = true;            fcs = true;
             fdc = true;          fde = true;           fdi = true;            fdl = true;
             fdm = true;          fdn = true;           fdt = true;            fen = true;
       fillchars = true;          fml = true;           fmr = true;     foldcolumn = true;
      foldenable = true;     foldexpr = true;    foldignore = true;      foldlevel = true;
      foldmarker = true;   foldmethod = true;  foldminlines = true;    foldnestmax = true;
        foldtext = true;          lbr = true;           lcs = true;      linebreak = true;
            list = true;    listchars = true;            nu = true;         number = true;
     numberwidth = true;          nuw = true; previewwindow = true;            pvw = true;
  relativenumber = true;    rightleft = true;  rightleftcmd = true;             rl = true;
             rlc = true;          rnu = true;           scb = true;            scl = true;
             scr = true;       scroll = true;    scrollbind = true;     signcolumn = true;
           spell = true;   statusline = true;           stl = true;            wfh = true;
             wfw = true;        winbl = true;      winblend = true;   winfixheight = true;
     winfixwidth = true; winhighlight = true;         winhl = true;           wrap = true;
}

-- `nvim.$method(...)` redirects to `nvim.api.nvim_$method(...)`
-- `nvim.fn.$method(...)` redirects to `vim.api.nvim_call_function($method, {...})`
-- TODO `nvim.ex.$command(...)` is approximately `:$command {...}.join(" ")`
-- `nvim.print(...)` is approximately `echo vim.inspect(...)`
-- `nvim.echo(...)` is approximately `echo table.concat({...}, '\n')`
-- Both methods cache the inital lookup in the metatable, but there is a small overhead regardless.
local nvim = setmetatable({
  print = nvim_print;
  echo = nvim_echo;
  fn = vim.fn or setmetatable({}, {
    __index = function(t, k)
      local f = function(...) return vim.api.nvim_call_function(k, {...}) end
      rawset(t, k, f)
      return f
    end
  });
  buf = setmetatable({
  }, {
    __index = function(t, k)
      local f
      if k == 'line' then
        f = function()
          local pos = vim.api.nvim_win_get_cursor(0)
          return vim.api.nvim_buf_get_lines(0, pos[1]-1, pos[1], 'line')[1]
        end
      elseif k == 'nr' then
        f = vim.api.nvim_get_current_buf
      end
      rawset(t, k, f)
      return f
    end
  });
  ex = setmetatable({}, {
    __index = function(t, k)
      local command = k:gsub("_$", "!")
      local f = function(...)
        return vim.api.nvim_command(table.concat(vim.tbl_flatten {command, ...}, " "))
      end
      rawset(t, k, f)
      return f
    end
  });
}, {
  __index = function(self, k)
    local mt = getmetatable(self)
    local x = mt[k]
    if x ~= nil then
      return x
    end
    local f = vim.api['nvim_'..k]
    mt[k] = f
    return f
  end
})

local a = vim.api
local validate = vim.validate
local function make_meta_accessor(get, set, del)
  validate {
    get = {get, 'f'};
    set = {set, 'f'};
    del = {del, 'f', true};
  }
  local mt = {}
  if del then
    function mt:__newindex(k, v)
      if v == nil then
        return del(k)
      end
      return set(k, v)
    end
  else
    function mt:__newindex(k, v)
      return set(k, v)
    end
  end
  function mt:__index(k)
    return get(k)
  end
  return setmetatable({}, mt)
end
local function pcall_ret(status, ...)
  if status then return ... end
end
local function nil_wrap(fn)
  return function(...)
    return pcall_ret(pcall(fn, ...))
  end
end
nvim.g = make_meta_accessor(nil_wrap(a.nvim_get_var), a.nvim_set_var, a.nvim_del_var)
nvim.v = make_meta_accessor(nil_wrap(a.nvim_get_vvar), a.nvim_set_vvar)
nvim.o = make_meta_accessor(a.nvim_get_option, a.nvim_set_option)
local function getenv(k)
  local v = vim.fn.getenv(k)
  if v == vim.NIL then
    return nil
  end
  return v
end
nvim.env = vim.env or make_meta_accessor(getenv, vim.fn.setenv)
local function new_win_accessor(winnr)
  local function get(k)    return a.nvim_win_get_var(winnr, k) end
  local function set(k, v) return a.nvim_win_set_var(winnr, k, v) end
  local function del(k)    return a.nvim_win_del_var(winnr, k) end
  return make_meta_accessor(nil_wrap(get), set, del)
end
nvim.w = new_win_accessor(0)
getmetatable(nvim.w).__call = function(_, winnr)
  return new_win_accessor(winnr)
end
local function new_buf_accessor(bufnr)
  local function get(k)    return a.nvim_buf_get_var(bufnr, k) end
  local function set(k, v) return a.nvim_buf_set_var(bufnr, k, v) end
  local function del(k)    return a.nvim_buf_del_var(bufnr, k) end
  return make_meta_accessor(nil_wrap(get), set, del)
end
nvim.b = new_buf_accessor(0)
getmetatable(nvim.b).__call = function(_, bufnr)
  return new_buf_accessor(bufnr)
end
local function new_buf_opt_accessor(bufnr)
  local function get(k)
    if window_options[k] then
      return a.nvim_err_writeln(k.." is a window option, not a buffer option")
    end
    return a.nvim_buf_get_option(bufnr, k)
  end
  local function set(k, v)
    if window_options[k] then
      return a.nvim_err_writeln(k.." is a window option, not a buffer option")
    end
    return a.nvim_buf_set_option(bufnr, k, v)
  end
  return make_meta_accessor(nil_wrap(get), set)
end
nvim.bo = vim.bo or new_buf_opt_accessor(0)
getmetatable(nvim.bo).__call = function(_, bufnr)
  return new_buf_opt_accessor(bufnr)
end
local function new_win_opt_accessor(winnr)
  local function get(k)    return a.nvim_win_get_option(winnr, k) end
  local function set(k, v) return a.nvim_win_set_option(winnr, k, v) end
  return make_meta_accessor(nil_wrap(get), set)
end
nvim.wo = vim.wo or new_win_opt_accessor(0)
getmetatable(nvim.wo).__call = function(_, winnr)
  return new_win_opt_accessor(winnr)
end

return nvim
-- vim:et ts=2 sw=2
