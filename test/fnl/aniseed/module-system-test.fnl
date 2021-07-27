(module aniseed.module-system-test
  {autoload {compile aniseed.compile}})

(deftest module
  (local initial {:foo :bar})

  (module module-test
          {require {a_ aniseed.core}
           autoload {compile_ aniseed.compile}}
          initial)
  
  (t.= *module-name* :module-test
       "*module-name* not defined")

  (t.= *file* :test/fnl/aniseed/module-system-test.fnl
       "*file* not defined")
  
  (t.ok? (not= nil a_) "require aniseed.core failed")
  (t.ok? (not= nil compile_) "autoload aniseed.compile failed")

  (t.= (. *module* :foo) (. initial :foo)
       "failed to carry over initial-mod into *module*")

  (let [(ok? result) (compile.str "(module)")]
    (t.ok? (not ok?) "compilation should return false")
    (t.= 30 (result:find "expected module name"))))

(deftest def
  (module def-test)
  
  (def a 3)
  (def- b 4)
  
  (t.= (* (. *module* :aniseed/locals :b)
          (. package.loaded :def-test :a)
          (. *module* :aniseed/locals :a))
       36 "failed to set all *module* sub tables properly")
  
  (t.ok? (= nil (. package.loaded :def-test :b))
         "def- declared variable is public")
  
  (let [(ok? result) (compile.str "(def)")]
    (t.ok? (not ok?) "compilation should return false")
    (t.= 30 (result:find "expected name")))

  (let [(ok? result) (compile.str "(def- name)")]
    (t.ok? (not ok?) "compilation should return false")
    (t.= 30 (result:find "expected value"))))

(deftest defn
  (module defn-test)
  
  (defn- f [x] (+ 2 x))
  (defn g [y z] (* 5 (- z (f y))))

  (t.= ((. *module* :g) 2 7) 15 "failed to properly define defns")
  
  (let [(ok? result) (compile.str "(defn name)")]
    (t.ok? (not ok?) "compilation should return false")
    (t.= 30 (result:find "expected parameters table")))

  (let [(ok? result) (compile.str "(defn- name [])")]
    (t.ok? (not ok?) "compilation should return false")
    (t.= 30 (result:find "expected body expression"))))

(deftest defonce
  (var calls 0)
  (fn inc []
    (set calls (+ calls 1))
    :ok)
  (t.= 0 calls)
  (defonce foo (inc))
  (t.= 1 calls)
  (defonce foo (inc))
  (t.= 1 calls)
  
  (let [(ok? result) (compile.str "(defonce)")]
    (t.ok? (not ok?) "compilation should return false")
    (t.= 30 (result:find "expected name"))))

(deftest deftest-
  (let [(ok? result) (compile.str "(deftest)")]
    (t.ok? (not ok?) "compilation should return false")
    (t.= 30 (result:find "expected name")))

  (let [(ok? result) (compile.str "(deftest name)")]
    (t.ok? (not ok?) "compilation should return false")
    (t.= 30 (result:find "expected body expression"))))

(deftest time
  (local x 4)
  (t.= (time
         (local y 5)
         (* x y))
       20 "time function failed")
  
  (t.= (time 42) 42 "second time function failed")
  
  (let [(ok? result) (compile.str "(time)")]
    (t.ok? (not ok?) "compilation should return false")
    (t.= 30 (result:find "expected body expression"))))
