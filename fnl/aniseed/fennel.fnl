(module aniseed.fennel
  {autoload {nvim aniseed.nvim
             str aniseed.string
             a aniseed.core
             fs aniseed.fs}})

(defn sync-rtp [compiler]
  "Synchronises the runtime paths into the fennel.macro-path"
  (let [fnl-suffix (.. fs.path-sep "fnl" fs.path-sep "?.fnl")]
    (tset compiler :macro-path
          (->> (nvim.list_runtime_paths)
               (a.map #(.. $ fnl-suffix))
               (str.join ";")))))

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
