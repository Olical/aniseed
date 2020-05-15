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
