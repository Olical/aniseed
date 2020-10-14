(module aniseed.env
  {require {nvim aniseed.nvim
            compile aniseed.compile}})

(def- config-dir (nvim.fn.stdpath :config))
(compile.add-path (.. config-dir "/?.fnl"))

(defn init [module-name]
  (compile.glob "**/*.fnl" (.. config-dir "/fnl") (.. config-dir "/lua"))
  (require (or module-name :init)))
