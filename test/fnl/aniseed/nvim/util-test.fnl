(module aniseed.nvim.util-test
  {require {nu aniseed.nvim.util
            a aniseed.core}})

(deftest with-out-str
  (t.= "" (nu.with-out-str (fn [] (+ 1 1))) "nothing")
  (t.pr= (values false "oh no")
         (pcall
           nu.with-out-str
           (fn []
             (a.println "foo")
             (error "oh no")))
         "error bubbles out but still resets *printer*")
  (t.= "foo\nbar\n"
       (nu.with-out-str
         (fn []
           (a.println "foo")
           (a.println "bar")))
       "two lines"))
