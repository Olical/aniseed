(module aniseed.eval-test
  {autoload {eval aniseed.eval
             a aniseed.core}})

(deftest str
  (t.pr= [true 10] [(eval.str "(+ 4 6)")])
  (let [(success? err) (eval.str "(ohno)")]
    (t.= false success?)
    (t.= "unknown global in strict mode: ohno"
         (string.match err "unknown global in strict mode: ohno"))))

(deftest repl
  ;; Basic usage with state carrying over!
  (let [eval (eval.repl)]
    (t.pr= ["3"] (eval "(+ 1 2)"))
    (t.pr= ["nil"] (eval "(local foo 10)"))
    (t.pr= ["25"] (eval "(+ 15 foo)")))

  ;; Error handling.
  (var last-error nil)
  (let [eval (eval.repl
               {:onError #(set last-error [$1 $2 $3])})]
    (t.pr= ["3"] (eval "(+ 1 2)"))
    (t.pr= ["nil"] (eval "(local foo 10)"))

    (t.= nil (eval "(ohno)"))
    (t.pr= ["Runtime"
            "[string \"local foo = ___replLocals___['foo']...\"]:9: attempt to call global 'ohno' (a nil value)"]
           last-error)

    (t.= nil (eval "(())"))
    (t.= "Compile" (a.first last-error))
    (t.= "expected a function" (string.match (a.last last-error) "expected a function"))

    (t.pr= ["15"] (eval "(+ foo 5)")))

  ;; Using Aniseed module macros.
  (let [eval (eval.repl)]
    (t.= "table: 0x" (string.match (a.first (eval "(module henlo)")) "table: 0x"))
    (t.pr= ["nil"] (eval "(def world 25)"))
    (t.pr= ["40"] (eval "(+ 15 world)"))))
