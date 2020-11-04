(module aniseed.fennel
  {require {nvim aniseed.nvim
            fennel aniseed.deps.fennel}}
  (require :aniseed.deps.fennel))

(let [suffix "/fnl/?.fnl"]
  (tset fennel :path (.. (nvim.o.runtimepath:gsub "," (.. suffix ";")) suffix)))
