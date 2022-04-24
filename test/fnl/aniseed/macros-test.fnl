(module aniseed.macros-test
  {autoload {{: identity} aniseed.core}})

(deftest defonce
  (set *module*.foo nil)

  (var calls 0)
  (fn inc []
    (set calls (+ calls 1))
    :ok)
  (t.= 0 calls)
  (defonce foo (inc))
  (t.= 1 calls)
  (defonce foo (inc))
  (t.= 1 calls)

  (t.= :destructure-require (identity :destructure-require)))
