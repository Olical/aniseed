(local core (require :aniseed.core))

{:aniseed/module :aniseed.core-test
 :aniseed/tests
 {:inc
  (fn [t]
    (t.= 2 (core.inc 1)))

  :pr-str
  (fn [t]
    (t.pr= [1 2 3] [1 2 3]))

  :map
  (fn [t]
    (t.pr= [2 3 4] (core.map core.inc [1 2 3])))}}
