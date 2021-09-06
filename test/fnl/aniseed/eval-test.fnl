(module aniseed.eval-test
  {autoload {eval aniseed.eval
             a aniseed.core}})

(defn contains? [s substr]
  (values
    substr
    (if (string.find s substr)
      substr
      s)))

(deftest str
  (t.pr= [true 10] [(eval.str "(+ 4 6)")])
  (let [(success? err) (eval.str "(ohno)")]
    (t.= false success?)
    (t.= (contains? err "unknown global in strict mode: ohno"))))

(deftest repl
  ;; Basic usage with state carrying over!
  (let [eval! (eval.repl)]
    (t.pr= [3] (eval! "(+ 1 2)"))
    (t.pr= [nil] (eval! "(local foo 10)"))
    (t.pr= [25] (eval! "(+ 15 foo)")))

  ;; Error handling.
  (var last-error nil)
  (let [eval! (eval.repl {:onError #(set last-error [$1 $2 $3])})]
    (t.pr= [3] (eval! "(+ 1 2)"))
    (t.pr= [nil] (eval! "(local foo 10)"))

    (t.= nil (eval! "(ohno)"))
    (t.= "Compile" (a.first last-error))
    (t.= (contains? (a.second last-error) "unknown global in strict mode: ohno"))

    (t.= nil (eval! "(())"))
    (t.= "Compile" (a.first last-error))
    (t.= (contains? (a.second last-error) "expected a function"))

    (t.= nil (eval! "(let [x nil] (.. :foo x :bar))"))
    (t.= "Runtime" (a.first last-error))
    (t.= (contains? (a.second last-error) "attempt to concatenate local 'x' %(a nil value%)"))

    (t.pr= [15] (eval! "(+ foo 5)"))

    (t.= nil (eval! "(error :ohno)"))
    (t.= "Runtime" (a.first last-error))
    (t.= (contains? (a.second last-error) "ohno")))

  ;; Using Aniseed module macros.
  (let [eval-a! (eval.repl)
        eval-b! (eval.repl)]
    ;; Ensure you can run this test multiple times in one session.
    (tset package.loaded :eval-test-module nil)

    ;; Creating a new module
    (t.pr= [] (eval-a! "(module eval-test-module)"))
    (t.pr= [] (eval-a! "(def world 25)"))
    (t.pr= [40] (eval-a! "(+ 15 world)"))

    ;; Entering an existing module
    (t.pr= [] (eval-b! "(module eval-test-module)"))
    (t.pr= [40] (eval-b! "(+ 15 world)"))))
