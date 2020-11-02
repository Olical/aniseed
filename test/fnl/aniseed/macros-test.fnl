(module aniseed.macros-test)

(when (os.getenv "ANISEED_DYNAMIC")
  (deftest defonce
    (var calls 0)
    (fn inc []
      (set calls (+ calls 1))
      :ok)
    (t.= 0 calls)
    (defonce foo (inc))
    (t.= 1 calls)
    (defonce foo (inc))
    (t.= 1 calls)))
