(local nvim (require :aniseed.nvim))
(local test (require :aniseed.test))

(require :aniseed.core-test)
(require :aniseed.compile-test)

(fn main []
  (nvim.ex.redir_ "> test/results.txt")

  (let [results (test.run-all)]
    (if (test.ok? results)
      (nvim.ex.q)
      (nvim.ex.cq))))

{:aniseed/module :aniseed.test-suite
 :main main}
