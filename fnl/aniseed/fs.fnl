(module aniseed.fs
  {autoload {nvim aniseed.nvim
             a aniseed.core}})

(defn basename [path]
  (nvim.fn.fnamemodify path ":h"))

(defn mkdirp [dir]
  (nvim.fn.mkdir dir "p"))

(defn relglob [dir expr]
  "Glob all files under dir matching the expression and return the paths
  relative to the dir argument."
  (let [dir-len (a.inc (string.len dir))]
    (->> (nvim.fn.globpath dir expr true true)
         (a.map #(string.sub $1 dir-len)))))

(defn glob-dir-newer? [a-dir b-dir expr b-dir-path-fn]
  "Returns true if a-dir has newer changes than b-dir. All paths from a-dir are mapped through b-dir-path-fn before comparing to b-dir."
  (var newer? false)
  (each [_ path (ipairs (relglob a-dir expr))]
    (when (> (nvim.fn.getftime (.. a-dir path))
             (nvim.fn.getftime (.. b-dir (b-dir-path-fn path))))
      (set newer? true)))
  newer?)

(defn macro-file-path? [path]
  "Check if the path is a specially treated Aniseed / Fennel macros file.
  We preserve these and don't try to compile them to Lua since you can't
  do that."
  (string.match path "macros.fnl$"))
