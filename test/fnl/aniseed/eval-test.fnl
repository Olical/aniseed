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
    (t.= (contains? err "unknown identifier in strict mode: ohno"))))

(deftest clean-error
  (t.= "[nope] it's okay" (eval.clean-error "[nope] it's okay"))
  (t.= "oh no" (eval.clean-error "[string [[[]]:10: oh no"))
  (t.= "attempt to call field 'secone' (a nil value)"
       (eval.clean-error "[string \"local a0 = ___replLocals___['a0']...\"]:49: attempt to call field 'secone' (a nil value)"))
  (t.= "expected a..."
       (eval.clean-error "Compile error in unknown:1\n  expected a...")))

(deftest repl
  ;; Basic usage with state carrying over!
  (let [eval! (eval.repl)]
    (t.pr= [3] (eval! "(+ 1 2)"))
    (t.pr= [nil] (eval! "(local foo 10)"))
    (t.pr= [25] (eval! "(+ 15 foo)")))

  ;; Error handling.
  (var last-error nil)
  (let [eval! (eval.repl {:error-handler #(set last-error $1)})]
    (t.pr= [3] (eval! "(+ 1 2)"))
    (t.pr= [nil] (eval! "(local foo 10)"))

    (t.= nil (eval! "(ohno)"))
    (t.= (contains? last-error "attempt to call global 'ohno' (a nil value)"))

    (t.= nil (eval! "(())"))
    (t.= (contains? last-error "expected a function"))

    (t.= nil (eval! "(let [x nil] (.. :foo x :bar))"))
    (t.= (contains? last-error "attempt to concatenate local 'x' %(a nil value%)"))

    (t.pr= [15] (eval! "(+ foo 5)"))

    (t.pr= nil (eval! "(((("))
    (t.pr= nil (eval! "))))"))
    (t.= (contains? last-error "expected a function, macro, or special to call"))

    (t.= nil (eval! "(error :ohno)"))
    (t.= (contains? last-error "ohno")))

  ;; Using Aniseed module macros.
  ;; TODO These tests are flaky... why!?
  (let [eval-a! (eval.repl)
        eval-b! (eval.repl)]
    ;; Ensure you can run this test multiple times in one session.
    (tset package.loaded :eval-test-module nil)

    ;; Creating a new module
    (t.pr= [] (eval-a! "(module eval-test-module)"))
    (t.pr= [] (eval-a! "(def world 25)"))
    (t.pr= [] (eval-a! "(def- shh 10)"))
    (t.pr= [40] (eval-a! "(+ 15 world)"))

    ;; Entering an existing module
    (t.pr= [] (eval-b! "(module eval-test-module)"))
    (t.pr= [40] (eval-b! "(+ 15 world)"))
    (t.pr= [25] (eval-b! "(+ 15 shh)"))
    (t.pr= [] (eval-b! "(def world (+ world 20))"))
    (t.pr= [] (eval-b! "(def- shh (+ shh 10))"))

    ;; And again!
    (let [eval-c! (eval.repl)]
      (t.pr= [] (eval-c! "(module eval-test-module)"))
      (t.pr= [60] (eval-c! "(+ 15 world)"))
      (t.pr= [35] (eval-c! "(+ 15 shh)")))))
