(local nvim (require :aniseed.nvim))

(fn ensure-parent-dirs [path]
  (let [parent (nvim.call-function :fnamemodify path ":h")]
    (nvim.call-function :mkdir parent "p")))

{:ensure-parent-dirs ensure-parent-dirs}
