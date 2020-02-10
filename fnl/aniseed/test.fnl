(module aniseed.test
  {require {core aniseed.core
            str aniseed.string
            nvim aniseed.nvim}})

(defn ok? [{: tests : tests-passed}]
  (= tests tests-passed))

(defn display-results [results prefix]
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

(defn run [mod-name]
  (let [mod (. package.loaded mod-name)
        tests (and (core.table? mod) (. mod :aniseed/tests))]
    (when (core.table? tests)
      (let [results {:tests (length tests)
                     :tests-passed 0
                     :assertions 0
                     :assertions-passed 0}]
        (each [label f (pairs tests)]
          (var test-failed false)
          (core.update results :tests core.inc)
          (let [prefix (.. "[" mod-name "/" label "]")
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
        (display-results results (.. "[" mod-name "]"))))))

(defn run-all []
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

(defn suite []
  (nvim.ex.redir_ "> test/results.txt")

  (->> (nvim.fn.globpath "test/fnl" "**/*-test.fnl" false true)
       (core.run!
         (fn [path]
           (-> path
               (string.match "^test/fnl/(.-).fnl$")
               (string.gsub "/" ".")
               (require)))))

  (let [results (run-all)]
    (if (ok? results)
      (nvim.ex.q)
      (nvim.ex.cq))))
