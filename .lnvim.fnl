;; Add the project directory to rtp for development.
(vim.api.nvim_set_option
  :runtimepath
  (.. (vim.api.nvim_get_option :runtimepath)
      "," (vim.api.nvim_call_function :getcwd [])))
