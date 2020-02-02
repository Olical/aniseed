(module aniseed.test-suite
  {require {nvim aniseed.nvim
            test aniseed.test}})

(defn main []
  (nvim.ex.redir_ "> test/results.txt")

  (require :aniseed.core-test)
  (require :aniseed.compile-test)
  (require :aniseed.fs-test)
  (require :aniseed.string-test)
  (require :aniseed.macros-test)

  (let [results (test.run-all)]
    (if (test.ok? results)
      (nvim.ex.q)
      (nvim.ex.cq))))
