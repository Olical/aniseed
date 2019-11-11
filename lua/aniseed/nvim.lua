local function call_function(f_name, ...)
  return vim.api.nvim_call_function(f_name, {...})
end
return {["call-function"] = call_function}
