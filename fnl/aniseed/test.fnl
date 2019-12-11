(local core (require :aniseed.core))

(fn ok? [{: tests : tests-passed}]
  (= tests tests-passed))

(fn display-results [results prefix]
  (let [{: tests
         : tests-passed
         : assertions
         : assertions-passed}
        results]
    (print (.. prefix " "
               (if (ok? results)
                 "OK"
                 "FAILED")
               " " tests-passed "/" tests " tests and "
               assertions-passed "/" assertions " assertions passed.")))
  results)

;; TODO Much better testing tools with descriptions etc.
(fn run [module-name]
  (let [module (. package.loaded module-name)
        tests (and (core.table? module) (. module :aniseed/tests))]
    (when (core.table? tests)
      (let [results {:tests (length tests)
                     :tests-passed 0
                     :assertions 0
                     :assertions-passed 0}]
        (each [label f (pairs tests)]
          (var test-failed false)
          (core.update results :tests core.inc)
          (let [prefix (.. "[" module-name "/" label "]")]
            (match (pcall
                     (fn []
                       (f (fn [...]
                            (core.update results :assertions core.inc)
                            (let [args [...]]
                              (var assertion-failed false)
                              (match args
                                [x y] (when (not= x y)
                                        (set assertion-failed true)
                                        (set test-failed true)
                                        (print (.. prefix " Expected '" (core.pr-str x) "' to equal '" (core.pr-str y) "'.")))
                                [x] (when (not x)
                                      (set assertion-failed true)
                                      (set test-failed true)
                                      (print (.. prefix " Expected '" (core.pr-str x) "' to be truthy."))))
                              (when (not assertion-failed)
                                (core.update results :assertions-passed core.inc)))))))
              (false err) (do
                            (set test-failed true)
                            (print (.. prefix " Exception: " err)))))
          (when (not test-failed)
            (core.update results :tests-passed core.inc)))
        (display-results results (.. "[" module-name "]"))))))

(fn run-all []
  (-> (core.keys package.loaded)
      (->> (core.map run)
           (core.filter core.table?)
           (core.reduce
             (fn [totals results]
               (each [k v (pairs results)]
                 (tset totals k (+ v (. totals k))))
               totals)
             {:tests 0
              :tests-passed 0
              :assertions 0
              :assertions-passed 0}))
      (display-results "[total]")))

{:aniseed/module :aniseed.test
 :ok? ok?
 :run run
 :run-all run-all}
