(local core (require :aniseed.core))
(local nvim (require :aniseed.nvim))

(fn basename [path]
  (nvim.fn.fnamemodify path ":h"))

(fn mkdirp [dir]
  (nvim.fn.mkdir dir "p"))

(core.module
  :aniseed.fs
  {:basename basename
   :mkdirp mkdirp})
