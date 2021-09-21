(module aniseed.fennel
  {autoload {nvim aniseed.nvim
             str aniseed.string
             a aniseed.core
             fs aniseed.fs}})

(defn sync-rtp [compiler]
  "Synchronises the runtime paths into the fennel.macro-path"
  (let [;; For direct macros under the fnl dir.
        fnl-suffix (.. fs.path-sep "fnl" fs.path-sep "?.fnl")

        ;; For macros embedded from other tools under your lua dir.
        lua-suffix (.. fs.path-sep "lua" fs.path-sep "?.fnl")

        rtps (nvim.list_runtime_paths)
        fnl-paths (a.map #(.. $ fnl-suffix) rtps)
        lua-paths (a.map #(.. $ lua-suffix) rtps)]
    (tset compiler :macro-path (str.join ";" (a.concat fnl-paths lua-paths)))))

(def- state {:compiler-loaded? false})

(defn impl []
  (let [compiler (require :aniseed.deps.fennel)]
    (when (not (. state :compiler-loaded?))
      (tset state :compiler-loaded? true)
      (sync-rtp compiler))
    compiler))

(defn add-path [path]
  "Adds the given path to the fennel.macro-path"
  (let [fnl (impl)]
    (tset fnl :macro-path (.. fnl.macro-path ";" path))))
