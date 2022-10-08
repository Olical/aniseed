(module aniseed.test
  {autoload {a aniseed.core
             fs aniseed.fs
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
    (a.println
      (.. prefix " "
          (if (ok? results)
            "OK"
            "FAILED")
          " " tests-passed "/" tests " tests and "
          assertions-passed "/" assertions " assertions passed")))
  results)

(defn run [mod-name]
  (let [mod (. _G.package.loaded mod-name)
        tests (and (a.table? mod) (. mod :aniseed/tests))]
    (when (a.table? tests)
      (let [results {:tests (length tests)
                     :tests-passed 0
                     :assertions 0
                     :assertions-passed 0}]
        (each [label f (pairs tests)]
          (var test-failed false)
          (a.update results :tests a.inc)
          (let [prefix (.. "[" mod-name "/" label "]")
                fail (fn [desc ...]
                       (set test-failed true)
                       (a.println (.. (str.join [prefix " " ...])
                                      (if desc
                                        (.. " (" desc ")")
                                        ""))))
                begin (fn []
                        (a.update results :assertions a.inc))
                pass (fn []
                       (a.update results :assertions-passed a.inc)) 

                t {:= (fn [e r desc]
                        (begin)
                        (if (= e r)
                          (pass)
                          (fail desc "Expected '" (a.pr-str e) "' but received '" (a.pr-str r) "'")))
                   :pr= (fn [e r desc]
                          (begin)
                          (let [se (a.pr-str e)
                                sr (a.pr-str r)]
                            (if (= se sr)
                              (pass)
                              (fail desc "Expected (with pr) '" se "' but received '" sr "'"))))
                   :ok? (fn [r desc]
                          (begin)
                          (if r
                            (pass)
                            (fail desc "Expected truthy result but received '" (a.pr-str r) "'")))}]
            (match (pcall
                     (fn []
                       (f t)))
              (false err) (fail "Exception: " err)))
          (when (not test-failed)
            (a.update results :tests-passed a.inc)))
        (display-results results (.. "[" mod-name "]"))))))

(defn run-all []
  (-> (a.keys _G.package.loaded)
      (->> ;; Drop any module that isn't a table or has a metatable.
           (a.remove (fn [mod-name]
                       (let [mod (a.get _G.package.loaded mod-name)]
                         (or (not (a.table? mod))
                             (getmetatable mod)))))

           ;; Run the tests for the module.
           (a.map run)

           ;; Only keep results that generated tables.
           (a.filter a.table?)

           ;; Reduce to a final set of counts.
           (a.reduce
             (fn [totals results]
               (each [k v (pairs results)]
                 (tset totals k (+ v (. totals k))))
               totals)
             {:tests 0
              :tests-passed 0
              :assertions 0
              :assertions-passed 0}))

      ;; And print them.
      (display-results "[total]")))

(defn suite []
  (let [sep fs.path-sep]
    (->> (nvim.fn.globpath (.. "test" sep "fnl") "**/*-test.fnl" false true)
         (a.run!
           (fn [path]
             (-> path
                 (string.match (.. "^test" sep "fnl" sep "(.-).fnl$"))
                 (string.gsub sep ".")
                 (require))))))

  (if (ok? (run-all))
    (nvim.ex.q)
    (nvim.ex.cq)))
