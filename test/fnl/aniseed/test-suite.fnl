(local nvim (require :aniseed.nvim))
(local test (require :aniseed.test))

(fn main []
  (nvim.ex.redir_ "> test/results.txt")

  (require :aniseed.core-test)
  (require :aniseed.compile-test)
  (require :aniseed.fs-test)
  (require :aniseed.string-test)

  (let [results (test.run-all)]
    (if (test.ok? results)
      (nvim.ex.q)
      (nvim.ex.cq))))

{:aniseed/module :aniseed.test-suite
 :main main}
