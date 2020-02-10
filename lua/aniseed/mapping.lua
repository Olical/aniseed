local _0_0 = nil
do
  local name_23_0_ = "aniseed.mapping"
  local loaded_23_0_ = package.loaded[name_23_0_]
  local module_23_0_ = nil
  if ("table" == type(loaded_23_0_)) then
    module_23_0_ = loaded_23_0_
  else
    module_23_0_ = {}
  end
  module_23_0_["aniseed/module"] = name_23_0_
  module_23_0_["aniseed/locals"] = (module_23_0_["aniseed/locals"] or {})
  module_23_0_["aniseed/local-fns"] = (module_23_0_["aniseed/local-fns"] or {})
  package.loaded[name_23_0_] = module_23_0_
  _0_0 = module_23_0_
end
local function _1_(...)
  _0_0["aniseed/local-fns"] = {require = {core = "aniseed.core", eval = "aniseed.eval", fennel = "aniseed.fennel", nu = "aniseed.nvim.util", nvim = "aniseed.nvim", str = "aniseed.string", test = "aniseed.test"}}
  return {require("aniseed.core"), require("aniseed.string"), require("aniseed.fennel"), require("aniseed.nvim"), require("aniseed.nvim.util"), require("aniseed.test"), require("aniseed.eval")}
end
local _2_ = _1_(...)
local core = _2_[1]
local str = _2_[2]
local fennel = _2_[3]
local nvim = _2_[4]
local nu = _2_[5]
local test = _2_[6]
local eval = _2_[7]
do local _ = ({nil, _0_0, nil})[2] end
local handle_result = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function handle_result0(ok_3f, x)
      do
        local mod = (core["table?"](x) and x["aniseed/module"])
        if mod then
          if (nil == package.loaded[mod]) then
            package.loaded[mod] = {}
          end
          for k, v in pairs(x) do
            package.loaded[mod][k] = v
          end
        end
      end
      local function _3_()
        return core.pr(x)
      end
      return vim.schedule(_3_)
    end
    v_23_0_0 = handle_result0
    _0_0["handle-result"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["handle-result"] = v_23_0_
  handle_result = v_23_0_
end
local selection = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function selection0(type, ...)
      local sel_backup = nvim.o.selection
      local _3_ = {...}
      local visual_3f = _3_[1]
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
        local selection1 = nvim.eval("@@")
        nvim.o.selection = sel_backup
        nvim.ex.let("@@ = g:aniseed_reg_backup")
        return selection1
      end
    end
    v_23_0_0 = selection0
    _0_0["selection"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["selection"] = v_23_0_
  selection = v_23_0_
end
local buffer_header_length = nil
do
  local v_23_0_ = 20
  _0_0["aniseed/locals"]["buffer-header-length"] = v_23_0_
  buffer_header_length = v_23_0_
end
local default_module_name = nil
do
  local v_23_0_ = "aniseed.user"
  _0_0["aniseed/locals"]["default-module-name"] = v_23_0_
  default_module_name = v_23_0_
end
local buffer_module_pattern = nil
do
  local v_23_0_ = "[(]%s*module%s*(.-)[%s){]"
  _0_0["aniseed/locals"]["buffer-module-pattern"] = v_23_0_
  buffer_module_pattern = v_23_0_
end
local buffer_module_name = nil
do
  local v_23_0_ = nil
  local function buffer_module_name0()
    local header = str.join("\n", nvim.buf_get_lines(0, 0, buffer_header_length, false))
    return (string.match(header, buffer_module_pattern) or default_module_name)
  end
  v_23_0_ = buffer_module_name0
  _0_0["aniseed/locals"]["buffer-module-name"] = v_23_0_
  buffer_module_name = v_23_0_
end
local eval_str = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_str0(code, opts)
      return handle_result(eval.str(("(module " .. buffer_module_name() .. ")" .. code), opts))
    end
    v_23_0_0 = eval_str0
    _0_0["eval-str"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval-str"] = v_23_0_
  eval_str = v_23_0_
end
local eval_selection = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_selection0(...)
      return eval_str(selection(...))
    end
    v_23_0_0 = eval_selection0
    _0_0["eval-selection"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval-selection"] = v_23_0_
  eval_selection = v_23_0_
end
local eval_range = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_range0(first_line, last_line)
      return eval_str(str.join("\n", nvim.fn.getline(first_line, last_line)))
    end
    v_23_0_0 = eval_range0
    _0_0["eval-range"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval-range"] = v_23_0_
  eval_range = v_23_0_
end
local eval_file = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function eval_file0(filename)
      return handle_result(eval.str(core.slurp(filename), {filename = filename}))
    end
    v_23_0_0 = eval_file0
    _0_0["eval-file"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["eval-file"] = v_23_0_
  eval_file = v_23_0_
end
local run_tests = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function run_tests0(name)
      return test.run(name)
    end
    v_23_0_0 = run_tests0
    _0_0["run-tests"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["run-tests"] = v_23_0_
  run_tests = v_23_0_
end
local run_all_tests = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function run_all_tests0()
      return test["run-all"]()
    end
    v_23_0_0 = run_all_tests0
    _0_0["run-all-tests"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["run-all-tests"] = v_23_0_
  run_all_tests = v_23_0_
end
local init = nil
do
  local v_23_0_ = nil
  do
    local v_23_0_0 = nil
    local function init0()
      nu["fn-bridge"]("AniseedSelection", "aniseed.mapping", "selection")
      nu["fn-bridge"]("AniseedEval", "aniseed.mapping", "eval-str")
      nu["fn-bridge"]("AniseedEvalFile", "aniseed.mapping", "eval-file")
      nu["fn-bridge"]("AniseedEvalRange", "aniseed.mapping", "eval-range", {range = true})
      nu["fn-bridge"]("AniseedEvalSelection", "aniseed.mapping", "eval-selection")
      nu["fn-bridge"]("AniseedRunTests", "aniseed.mapping", "run-tests")
      nu["fn-bridge"]("AniseedRunAllTests", "aniseed.mapping", "run-all-tests")
      nvim.ex.command_("-nargs=1", "AniseedEval", "call AniseedEval(<q-args>)")
      nvim.ex.command_("-nargs=1", "AniseedEvalFile", "call AniseedEvalFile(<q-args>)")
      nvim.ex.command_("-range", "AniseedEvalRange", "<line1>,<line2>call AniseedEvalRange()")
      nvim.ex.command_("-nargs=1", "AniseedRunTests", "call AniseedRunTests(<q-args>)")
      nvim.ex.command_("-nargs=0", "AniseedRunAllTests", "call AniseedRunAllTests()")
      nvim.set_keymap("n", "<Plug>(AniseedEval)", ":set opfunc=AniseedEvalSelection<cr>g@", {noremap = true, silent = true})
      nvim.set_keymap("n", "<Plug>(AniseedEvalCurrentFile)", ":call AniseedEvalFile(expand('%'))<cr>", {noremap = true, silent = true})
      return nvim.set_keymap("v", "<Plug>(AniseedEvalSelection)", ":<c-u>call AniseedEvalSelection(visualmode(), v:true)<cr>", {noremap = true, silent = true})
    end
    v_23_0_0 = init0
    _0_0["init"] = v_23_0_0
    v_23_0_ = v_23_0_0
  end
  _0_0["aniseed/locals"]["init"] = v_23_0_
  init = v_23_0_
end
return nil
