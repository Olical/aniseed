(require-macros :aniseed.macros)

(module aniseed.compile-test
  {require {core aniseed.core
            compile aniseed.compile}})

(deftest str
  (let [(success result) (compile.str "(+ 10 20)")]
    (t.ok? success "compilation should return true")
    (t.= "return (10 + 20)" result "results include a return and parens"))

  (let [(success result) (compile.str "(+ 10 20")]
    (t.ok? (not success))
    (t.= 1 (core.first [(result:find "expected closing delimiter")]))))
