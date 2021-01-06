(module aniseed.fennel
  {require {nvim aniseed.nvim
            fennel aniseed.deps.fennel}}
  (require :aniseed.deps.fennel))

(let [fnl-suffixes (-> package.path
                       (string.gsub "%.lua;" ".fnl;")
                       (string.gsub "%.lua$" ".fnl"))]
  (set fennel.path
       (.. (string.gsub fnl-suffixes "/lua/" "/fnl/")
           ";" fnl-suffixes)))
