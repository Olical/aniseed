(local core (require :aniseed.core))

{:aniseed/module :aniseed.core-test
 :aniseed/tests
 {:inc
  (fn [t]
    (t.= 2 (core.inc 1)))

  :pr-str
  (fn [t]
    (t.= "[1 2 3]" (core.pr-str [1 2 3])))

  :map
  (fn [t]
    (t.= "[2 3 4]" (-> (core.map core.inc [1 2 3])
                       (core.pr-str))))}}
