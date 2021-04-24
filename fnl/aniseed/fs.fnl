(module aniseed.fs
  {autoload {nvim aniseed.nvim}})

(defn basename [path]
  (nvim.fn.fnamemodify path ":h"))

(defn mkdirp [dir]
  (nvim.fn.mkdir dir "p"))
