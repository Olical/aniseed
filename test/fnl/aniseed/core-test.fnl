(local core (require :aniseed.core))

{:aniseed/module :aniseed.core-test
 :aniseed/tests
 {:inc
  (fn [t]
    (t.= 2 (core.inc 1)))

  :pr-str
  (fn [t]
    (t.pr= "[1 2 3]" (core.pr-str [1 2 3])))

  :map
  (fn [t]
    (t.pr= [2 3 4] (core.map core.inc [1 2 3])))

  :inc
  (fn [t]
    (t.= 5 (core.inc 4)))

  :identity
  (fn [t]
    (t.= :hello (core.identity :hello) "returns what you give it")
    (t.= nil (core.identity) "no arg returns nil"))

  :concat
  (fn [t]
    (local orig [1 2 3])
    (t.pr= [1 2 3 4 5 6] (core.concat orig [4 5 6]) "table has been concatenated")
    (t.pr= [4 5 6 1 2 3] (core.concat [4 5 6] orig) "order is important")
    (t.pr= [1 2 3] orig "original hasn't been modified"))

  :first
  (fn [t]
    (t.= 1 (core.first [1 2 3]) "1 is first")
    (t.= nil (core.first nil) "first of nil is nil"))

  :last
  (fn [t]
    (t.= 3 (core.last [1 2 3]) "3 is last")
    (t.= nil (core.last nil) "last of nil is nil"))
  
  :count
  (fn [t]
    (t.= 3 (core.count [1 2 3]) "three values")
    (t.= 0 (core.count []) "empty")
    (t.= 0 (core.count nil) "nil")
    (t.= 0 (core.count nil) "no arg")
    (t.= 3 (core.count [1 nil 3]) "nil gap")
    (t.= 4 (core.count [nil nil nil :a]) "mostly nils")
    (t.= 0 (core.count {:a 1 :b 2}) "associative doesn't work"))}}
