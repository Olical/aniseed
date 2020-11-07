(module aniseed.env
  {require {a aniseed.core
            nvim aniseed.nvim
            compile aniseed.compile}})

(def- config-dir (nvim.fn.stdpath :config))
(compile.add-path (.. config-dir "/?.fnl"))

(defn init [opts]
  ;; TODO Document if it works well.
  (when (or (a.get opts :compile true)
            (os.getenv "ANISEED_ENV_COMPILE"))
    (compile.glob
      "**/*.fnl"
      (.. config-dir (a.get opts :input "/fnl"))
      (.. config-dir (a.get opts :output "/lua"))))
  (require (a.get opts :module :init)))
