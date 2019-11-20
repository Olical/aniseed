(local nvim (require :aniseed.nvim))

(fn ensure-ancestor-dirs [path]
  "Given a file path, ensures all directories above it exist with mkdir -p."
  (let [parent (nvim.fn.fnamemodify path ":h")]
    (nvim.fn.mkdir parent "p")))

{:aniseed/module :aniseed.fs

 :ensure-ancestor-dirs ensure-ancestor-dirs}
