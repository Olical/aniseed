(module aniseed.fennel
  {require {nvim aniseed.nvim
            fennel aniseed.deps.fennel}}
  (require :aniseed.deps.fennel))

(nvim.ex.let "&runtimepath = &runtimepath")

(tset fennel :path
      (-> package.path
          (string.gsub "/lua/" "/fnl/")
          (string.gsub ".lua;" ".fnl;")
          (string.gsub ".lua$" ".fnl")))
