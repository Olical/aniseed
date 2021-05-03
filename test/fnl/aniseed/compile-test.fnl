(module aniseed.compile-test
  {autoload {a aniseed.core
             compile aniseed.compile}})

(deftest str
  (let [(success result) (compile.str "(+ 10 20)")]
    (t.ok? success "compilation should return true")
    (t.= "local _2afile_2a = nil\nreturn (10 + 20)" result "results include a return and parens"))

  (let [(success result) (compile.str "(+ 10 20")]
    (t.ok? (not success))
    (t.= 28 (result:find "expected closing delimiter"))))
