(module aniseed.module-system-test)

(deftest module
  (local initial {:foo :bar})

  (module module-test
          {require {{: println &as a} aniseed.core}
           autoload {compile aniseed.compile}}
          initial)
  
  (t.= *module-name* :module-test
       "*module-name* not defined")

  (t.= *file* :test/fnl/aniseed/module-system-test.fnl
       "*file* not defined")
  
  (t.ok? (and (not= nil println)
              (not= nil a.println)
              (= println a.println)) "module-level `require` destructuring failed")
  (t.ok? (not= nil compile) "autoload aniseed.compile failed")

  (t.= (. *module* :foo) (. initial :foo)
       "failed to carry over initial-mod into *module*"))

(deftest def
  (module def-test)
  
  (def a 3)
  (def- b 4)
  
  (t.= (* (. *module* :aniseed/locals :b)
          (. package.loaded :def-test :a)
          (. *module* :aniseed/locals :a))
       36 "failed to set all *module* sub tables properly")
  
  (t.ok? (= nil (. package.loaded :def-test :b))
         "def- declared variable is public"))

(deftest defn
  (module defn-test)
  
  (defn- f [x] (+ 2 x))
  (defn g [y z] (* 5 (- z (f y))))

  (t.= ((. *module* :g) 2 7) 15 "failed to properly define defns")
  
  (defn h [x] (if (< x 21) (h (+ 1 x)) x))
  
  (t.ok? (= (h 2)
            (h 20)
            (h -4)
            21) "self reference/recursion failure"))

(deftest defonce
  (var calls 0)
  (fn inc []
    (set calls (+ calls 1))
    :ok)
  (t.= 0 calls)
  (defonce foo (inc))
  (t.= 1 calls)
  (defonce foo (inc))
  (t.= 1 calls))

(deftest time
  (local x 4)
  (t.= (time
         (local y 5)
         (* x y))
       20 "time function failed")
  
  (t.= (time 42) 42 "second time function failed"))
