(local nvim (require :aniseed.nvim))
(local fennel (require :aniseed.deps.fennel))

(nvim.ex.let "&runtimepath = &runtimepath")

(tset fennel :path
      (-> package.path
          (string.gsub "/lua/" "/fnl/")
          (string.gsub ".lua;" ".fnl;")
          (string.gsub ".lua$" ".fnl")))

(tset fennel :aniseed/module :aniseed.fennel)

fennel
