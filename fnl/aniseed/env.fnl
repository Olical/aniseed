(module aniseed.env)

(def- config-dir (vim.api.nvim_call_function :stdpath [:config]))
(defonce- state {:path-added? false})

(defn init [opts]
  (let [opts (or opts {})]
    (when (or (not= false opts.compile)
              (os.getenv "ANISEED_ENV_COMPILE"))
      (let [compile (require :aniseed.compile)
            fennel (require :aniseed.fennel)]

        (when (not state.path-added?)
          (fennel.add-path (.. config-dir "/?.fnl"))
          (set state.path-added? true))

        (compile.glob
          "**/*.fnl"
          (.. config-dir (or opts.input "/fnl"))
          (.. config-dir (or opts.output "/lua"))
          opts)))
    (require (or opts.module :init))))
