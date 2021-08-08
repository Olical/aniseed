(module aniseed.fennel
  {autoload {nvim aniseed.nvim
             fs aniseed.fs}})

(defn sync-rtp [compiler]
  "Synchronises the runtimepath into the fennel.path"
  (let [sep fs.path-sep
        fnl-suffix (.. sep "fnl" sep "?.fnl")
        rtp nvim.o.runtimepath
        fnl-path (.. (rtp:gsub "," (.. fnl-suffix ";")) fnl-suffix)
        lua-path (fnl-path:gsub (.. sep "fnl" sep) (.. sep "lua" sep))
        full-path (.. fnl-path ";" lua-path)]
    (tset compiler :path full-path)
    (tset compiler :macro-path full-path)))

(def- state {:compiler-loaded? false})

(defn impl []
  (let [compiler (require :aniseed.deps.fennel)]
    (when (not (. state :compiler-loaded?))
      (tset state :compiler-loaded? true)
      (sync-rtp compiler))
    compiler))

(defn add-path [path]
  "Adds the given path to the fennel.path"
  (let [fnl (impl)]
    (tset fnl :path
          (.. fnl.path ";" path))))
