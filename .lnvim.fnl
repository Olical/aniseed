;; Add the project directory to rtp for development.
(let [cwd (vim.api.nvim_call_function :getcwd [])]
  (vim.api.nvim_set_option
    :runtimepath
    (.. (vim.api.nvim_get_option :runtimepath)
        "," cwd

        ;; TODO Why won't this let me eval aniseed/string.fnl?
        "," cwd "/macros")))
