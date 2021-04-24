(module aniseed.fennel
  {autoload {nvim aniseed.nvim
             fennel aniseed.deps.fennel}}
  (require :aniseed.deps.fennel))

(defn add-path [path]
  "Adds the given path to the fennel.path"
  (set fennel.path
       (.. fennel.path ";" path)))

(defn sync-rtp []
  "Synchronises the runtimepath into the fennel.path"
  (let [fnl-suffix "/fnl/?.fnl"
        rtp nvim.o.runtimepath
        fnl-path (.. (rtp:gsub "," (.. fnl-suffix ";")) fnl-suffix)
        lua-path (fnl-path:gsub "/fnl/" "/lua/")]
    (tset fennel :path (.. fnl-path ";" lua-path))))

;; Synchronise the runtimepath on startup.
(sync-rtp)
