(module aniseed.eval-test
  {autoload {eval aniseed.eval
             a aniseed.core}})

(deftest str
  (t.pr= [true 10] [(eval.str "(+ 4 6)")])
  (let [(success? err) (eval.str "(ohno)")]
    (t.= false success?)
    (t.ok? (string.match err "unknown global in strict mode: ohno"))))

(deftest repl
  ;; Basic usage with state carrying over!
  (let [eval (eval.repl)]
    (t.pr= [3] (eval "(+ 1 2)"))
    (t.pr= [nil] (eval "(local foo 10)"))
    (t.pr= [25] (eval "(+ 15 foo)")))

  ;; Error handling.
  (var last-error nil)
  (let [eval (eval.repl {:onError #(set last-error [$1 $2 $3])})]
    (t.pr= [3] (eval "(+ 1 2)"))
    (t.pr= [nil] (eval "(local foo 10)"))

    (t.= nil (eval "(ohno)"))
    (t.= "Compile" (a.first last-error))
    (t.ok? (string.match (a.second last-error) "unknown global in strict mode: ohno"))
    (t.= nil (eval "(())"))
    (t.= "Compile" (a.first last-error))
    (t.ok? (string.match (a.second last-error) "expected a function"))

    (t.pr= [15] (eval "(+ foo 5)")))

  ;; Using Aniseed module macros.
  (let [eval1 (eval.repl)
        eval2 (eval.repl)]
    ;; Ensure you can run this test multiple times in one session.
    (tset package.loaded :eval-test-module nil)

    ;; Creating a new module
    (t.pr= [] (eval1 "(module eval-test-module)"))
    (t.pr= [] (eval1 "(def world 25)"))
    (t.pr= [40] (eval1 "(+ 15 world)"))

    ;; Entering an existing module
    (t.pr= [] (eval2 "(module eval-test-module)"))
    (t.pr= [40] (eval2 "(+ 15 world)"))))
