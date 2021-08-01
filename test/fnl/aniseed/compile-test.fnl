(module aniseed.compile-test
  {autoload {compile aniseed.compile}})

(defn- compile-fail [t code loc msg]
  (let [(success result) (compile.str code)]
    (t.ok? (not success) "compilation should fail")
    (t.= loc (result:find msg))))

(deftest str
  (let [(success result) (compile.str "(+ 10 20)")]
    (t.ok? success "compilation should return true")
    (t.= "return (10 + 20)" result "results include a return and parens"))

  (compile-fail t "(+ 10 20" 28 "expected closing delimiter"))

(deftest module
  (compile-fail t "(module)" 30 "expected name")

  (compile-fail t "(module _ {autoload {{&as root} base}})"
                30 "expected symbol, destructuring not yet supported for `autoload`"))

(deftest def
  (compile-fail t "(def)" 30 "expected name")
  (compile-fail t "(def-)" 30 "expected name")

  (compile-fail t "(def name)" 30 "expected value")
  (compile-fail t "(def- name)" 30 "expected value"))

(deftest defn
  (compile-fail t "(defn name)" 30 "expected parameters table")
  (compile-fail t "(defn- name)" 30 "expected parameters table")

  (compile-fail t "(defn name [])" 30 "expected body expression")
  (compile-fail t "(defn- name [])" 30 "expected body expression"))

(deftest defonce
  (compile-fail t "(defonce)" 30 "expected name")
  (compile-fail t "(defonce-)" 30 "expected name"))

(deftest deftest
  (compile-fail t "(deftest)" 30 "expected name")
  (compile-fail t "(deftest name)" 30 "expected body expression"))

(deftest time
  (compile-fail t "(time)" 30 "expected body expression"))
