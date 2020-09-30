(module aniseed.nvim.util-test
  {require {nvim aniseed.nvim
            nu aniseed.nvim.util
            a aniseed.core}})

(defn- safe-with-out-str [...]
  "Wrapper around with-out-str so as not to break tests."
  (let [result (nu.with-out-str ...)]
    (nvim.ex.redir ">> test/results.txt")
    result))

(deftest with-out-str
  (t.= "" (safe-with-out-str (fn [] (+ 1 1))) "nothing")
  (t.pr= (values false "oh no")
         (pcall
           safe-with-out-str
           (fn []
             (a.println "foo")
             (error "oh no")))
         "error bubbles out but still resets *printer*")
  (t.= "foo\nbar\n"
       (safe-with-out-str
         (fn []
           (a.println "foo")
           (a.println "bar")))
       "two lines"))

(def state {:fn-bridge-last-args nil})
(defn fn-bridge-spy [...]
  (set state.fn-bridge-last-args [...])
  :done)

(deftest fn-bridge
  ;; Defaults, no opts.
  (nu.fn-bridge :SomeAniseedTestFn :aniseed.nvim.util-test :fn-bridge-spy)
  (let [result (nvim.fn.SomeAniseedTestFn 1 2 3)]
    (t.= :done result)
    (t.pr= [1 2 3] state.fn-bridge-last-args))

  ;; No return value.
  (nu.fn-bridge :SomeAniseedTestFn :aniseed.nvim.util-test :fn-bridge-spy {:return false})
  (let [result (nvim.fn.SomeAniseedTestFn :a :b :c)]
    (t.= 0 result)
    (t.pr= [:a :b :c] state.fn-bridge-last-args)))
