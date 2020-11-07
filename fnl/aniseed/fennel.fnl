(module aniseed.fennel
  {require {nvim aniseed.nvim
            fennel aniseed.deps.fennel}}
  (require :aniseed.deps.fennel))

(let [fnl-suffix "/fnl/?.fnl"
      rtp nvim.o.runtimepath
      fnl-path (.. (rtp:gsub "," (.. fnl-suffix ";")) fnl-suffix)
      lua-path (fnl-path:gsub "/fnl/" "/lua/")]
  (tset fennel :path (.. fnl-path ";" lua-path)))
