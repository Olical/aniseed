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
  (a.string? (string.match path "macros?.fnl$")))

(def path-sep
  ;; https://github.com/nvim-lua/plenary.nvim/blob/8bae2c1fadc9ed5bfcfb5ecbd0c0c4d7d40cb974/lua/plenary/path.lua#L20-L31
  (if jit (let [os (string.lower jit.os)]
              (if (or (= :linux os)
                      (= :osx os)
                      (= :bsd os))
                  "/"
                  "\\"))
         (package.config:sub 1 1)))
