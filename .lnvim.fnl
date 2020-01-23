;; Add the project directory to rtp for development.
;; TODO Does this work? Should I just use my plugin manager?
(vim.api.nvim_set_option
  :runtimepath
  (.. (vim.api.nvim_get_option :runtimepath)
      "," (vim.api.nvim_call_function :getcwd [])))
