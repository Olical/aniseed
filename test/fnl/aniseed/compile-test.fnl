(local core (require :aniseed.core))
(local compile (require :aniseed.compile))

{:aniseed/module :aniseed.compile-test
 :aniseed/tests
 {:str
  (fn [is]
    (let [(success result) (compile.str "(+ 10 20)")]
      (is success)
      (is "return (10 + 20)" result))

    (let [(success result) (compile.str "(+ 10 20")]
      (is (not success))
      (is 1 (core.first [(result:find "expected closing delimiter")]))))}}
