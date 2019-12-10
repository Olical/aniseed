(local core (require :aniseed.core))

(local tests {})

(fn define [label f]
  (tset tests label f))

;; TODO Maybe a way to describe tests / document why they might fail?

(fn run []
  (local results {:tests 0
                  :assertions 0
                  :passed 0
                  :failed 0})
  (each [label f (pairs tests)]
    (core.update results :tests core.inc)
    (match (pcall
             (fn []
               (f (fn [...]
                    (core.update results :assertions core.inc)
                    (let [args [...]]
                      (var failed false)
                      (match args
                        [x y] (when (not= x y)
                                (set failed true)
                                (print (.. label ": Expected '" (core.pr-str x) "' to equal '" (core.pr-str y) "'.")))
                        [x] (when (not x)
                              (set failed true)
                              (print (.. label ": Expected '" (core.pr-str x) "' to be truthy."))))
                      (core.update
                        results
                        (if failed
                          :failed
                          :passed)
                        core.inc))))))
      (false err) (do
                    (print (.. label ": Exception! " err))
                    (core.update results :failed core.inc))))
  (print (.. "Tests complete: " (core.pr-str results)))
  results)

{:aniseed/module :aniseed.test
 :tests tests
 :define define
 :run run}
