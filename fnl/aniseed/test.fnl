(local core (require :aniseed.core))
(local str (require :aniseed.string))

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
               assertions-passed "/" assertions " assertions passed")))
  results)

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
          (let [prefix (.. "[" module-name "/" label "]")
                fail (fn [desc ...]
                       (set test-failed true)
                       (print (.. (str.join [prefix " " ...])
                                  (if desc
                                    (.. " (" desc ")")
                                    ""))))
                begin (fn []
                        (core.update results :assertions core.inc))
                pass (fn []
                       (core.update results :assertions-passed core.inc)) 

                ;; TODO Negated fns
                ;; TODO pr-str comparisons (s= like serialised=?)
                t {:= (fn [e r desc]
                        (begin)
                        (if (= e r)
                          (pass)
                          (fail desc "Expected '" (core.pr-str e) "' but received '" (core.pr-str r) "'")))
                   :pr= (fn [e r desc]
                         (begin)
                         (let [se (core.pr-str e)
                               sr (core.pr-str r)]
                           (if (= se sr)
                             (pass)
                             (fail desc "Expected (with pr) '" se "' but received '" sr "'"))))
                   :ok? (fn [r desc]
                          (begin)
                          (if r
                            (pass)
                            (fail desc "Expected truthy result but received '" (core.pr-str r) "'")))}]
            (match (pcall
                     (fn []
                       (f t)))
              (false err) (fail "Exception: " err)))
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
