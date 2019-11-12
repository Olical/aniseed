(local nvim (require :aniseed.nvim))

(fn ensure-ancestor-dirs [path]
  (let [parent (nvim.fn.fnamemodify path ":h")]
    (nvim.fn.mkdir parent "p")))

{:ensure-ancestor-dirs ensure-ancestor-dirs}
