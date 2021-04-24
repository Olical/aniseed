(module aniseed.env
  {autoload {nvim aniseed.nvim}})

(def- config-dir (nvim.fn.stdpath :config))
(defonce- state {:path-added? false})

(defn- quiet-require [m]
  (let [(ok? err) (pcall #(require m))]
    (when (and (not ok?)
               (not (err:find (.. "module '" m "' not found"))))
      (nvim.ex.echoerr err))))

(defn init [opts]
  (let [opts (if (= :table (type opts))
               opts
               {})]
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
    (quiet-require (or opts.module :init))))
