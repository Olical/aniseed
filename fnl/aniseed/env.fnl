(module aniseed.env
  {autoload {nvim aniseed.nvim
             fs aniseed.fs
             compile aniseed.compile
             fennel aniseed.fennel}})

;; The stdpath function can lead to mixed path separators on Windows.
;; We unify them all as forward slashes.
;; https://github.com/Olical/aniseed/issues/47
(def- config-dir
  (-> (nvim.fn.stdpath :config)
      (string.gsub "\\" "/")))


(defn- quiet-require [m]
  (let [(ok? err) (pcall #(require m))]
    (when (and (not ok?)
               (not (err:find (.. "module '" m "' not found"))))
      (nvim.ex.echoerr err))))

(defn init [opts]
  (let [opts (if (= :table (type opts))
               opts
               {})
        glob-expr "**/*.fnl" 
        fnl-dir (or opts.input (.. config-dir "/fnl"))
        lua-dir (or opts.output (.. config-dir "/lua"))]

    ;; Support requiring Lua modules from non-standard output directories.
    (set package.path (.. package.path ";" lua-dir "/?.lua"))

    (when
      (and
        ;; Need to have compiling enabled.
        (or (not= false opts.compile)
            (os.getenv "ANISEED_ENV_COMPILE"))

        ;; And a source Fennel file needs to be new than it's compiled
        ;; Lua counterpart.
        (fs.glob-dir-newer?
          fnl-dir lua-dir glob-expr
          (fn [path]
            (if (fs.macro-file-path? path)
              path
              (string.gsub path ".fnl$" ".lua")))))

      ;; Ensure the Fennel source files are findable.
      (fennel.add-path (.. fnl-dir "/?.fnl"))

      ;; Compile all source files.
      (compile.glob glob-expr fnl-dir lua-dir opts))

    (quiet-require (or opts.module :init))))
