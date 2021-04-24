(module aniseed.dotfiles
  {autoload {nvim aniseed.nvim
             compile aniseed.compile
             fennel aniseed.fennel}})

(nvim.out_write "Warning: aniseed.dotfiles is deprecated, see :help aniseed-dotfiles\n")

(def- config-dir (nvim.fn.stdpath :config))
(fennel.add-path (.. config-dir "/?.fnl"))
(compile.glob "**/*.fnl" (.. config-dir "/fnl") (.. config-dir "/lua"))
(require :dotfiles.init)
