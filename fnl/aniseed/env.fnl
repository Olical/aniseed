(module aniseed.env
  {require {a aniseed.core
            nvim aniseed.nvim
            compile aniseed.compile}})

(def- config-dir (nvim.fn.stdpath :config))
(compile.add-path (.. config-dir "/?.fnl"))

(defn init [opts]
  (compile.glob
    "**/*.fnl"
    (.. config-dir (a.get opts :input "/fnl"))
    (.. config-dir (a.get opts :output "/lua")))
  (require (a.get opts :module :init)))
