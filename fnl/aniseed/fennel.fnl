(module aniseed.fennel
  {autoload {nvim aniseed.nvim}})

(def impl #(require :aniseed.deps.fennel))

(defn add-path [path]
  "Adds the given path to the fennel.path"
  (let [fnl (impl)]
    (tset fnl :path
          (.. fnl.path ";" path))))

(defn sync-rtp []
  "Synchronises the runtimepath into the fennel.path"
  (let [fnl-suffix "/fnl/?.fnl"
        rtp nvim.o.runtimepath
        fnl-path (.. (rtp:gsub "," (.. fnl-suffix ";")) fnl-suffix)
        lua-path (fnl-path:gsub "/fnl/" "/lua/")]
    (tset (impl) :path (.. fnl-path ";" lua-path))))

;; Synchronise the runtimepath when this module is loaded.
(sync-rtp)
