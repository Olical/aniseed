(module aniseed.dotfiles
  {require {nvim aniseed.nvim
            compile aniseed.compile}})

(def- config-dir (nvim.fn.stdpath :config))
(compile.add-path (.. config-dir "/?.fnl"))
(compile.glob "**/*.fnl" (.. config-dir "/fnl") (.. config-dir "/lua"))
(require :dotfiles.init)
