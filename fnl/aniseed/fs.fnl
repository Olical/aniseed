(module aniseed.fs
  {require {nvim aniseed.nvim}})

(defn basename [path]
  (nvim.fn.fnamemodify path ":h"))

(defn mkdirp [dir]
  (nvim.fn.mkdir dir "p"))
