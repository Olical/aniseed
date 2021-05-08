(module aniseed.env
  {autoload {nvim aniseed.nvim
             compile aniseed.compile
             fennel aniseed.fennel}})

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
               {})
        fnl-dir (or opts.input "/fnl")
        lua-dir (or opts.output "/lua")]

    ;; Support requiring Lua modules from non-standard output directories.
    (set package.path (.. package.path ";" lua-dir "/?.lua"))

    (when (or (not= false opts.compile)
              (os.getenv "ANISEED_ENV_COMPILE"))

      (tset opts :on-pre-compile
            (fn []
              (when (not state.path-added?)
                ;; Allow finding Fennel source files and macros.
                (fennel.add-path (.. config-dir "/?.fnl"))

                ;; We only want to do this once!
                (set state.path-added? true))))

      (compile.glob
        "**/*.fnl"
        (.. config-dir fnl-dir)
        (.. config-dir lua-dir)
        opts))

    (quiet-require (or opts.module :init))))
