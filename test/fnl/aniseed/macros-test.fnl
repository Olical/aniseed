(require-macros :aniseed.macros)

(module aniseed.macros-test)

{:aniseed/module :aniseed.macros-test
 :aniseed/tests
 {:defonce
  (fn [t]
    (var calls 0)
    (fn inc []
      (set calls (+ calls 1))
      :ok)
    (t.= 0 calls)
    (defonce foo (inc))
    (t.= 1 calls)
    (defonce foo (inc))
    (t.= 1 calls))}}
