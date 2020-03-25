(module aniseed.core-test
  {require {core aniseed.core}})

(deftest first
  (t.= 1 (core.first [1 2 3]) "1 is first")
  (t.= nil (core.first nil) "first of nil is nil"))

(deftest last
  (t.= 3 (core.last [1 2 3]) "3 is last")
  (t.= nil (core.last nil) "last of nil is nil"))

(deftest second
  (t.= nil (core.second []) "nil when empty")
  (t.= nil (core.second nil) "nil when nil")
  (t.= nil (core.second [1 nil 3]) "nil when the second item is actually nil")
  (t.= 2 (core.second [1 2 3]) "two when the second item is two"))

(deftest string?
  (t.= true (core.string? "foo"))
  (t.= false (core.string? nil))
  (t.= false (core.string? 10)))

(deftest nil?
  (t.= false (core.nil? "foo"))
  (t.= true (core.nil? nil))
  (t.= false (core.nil? 10)))

(deftest some
  (t.= nil (core.some #(and (> $1 5) $1) [1 2 3]) "nil when nothing matches")
  (t.= 3 (core.some #(and (> $1 2) $1) [1 2 3]) "the value when something matches")
  (t.= 3 (core.some #(and $1 (> $1 2) $1) [nil 1 nil 2 nil 3 nil]) "handles nils"))

(deftest inc
  (t.= 2 (core.inc 1))
  (t.= -4 (core.inc -5)))

(deftest dec
  (t.= 1 (core.dec 2))
  (t.= -6 (core.dec -5)))

(deftest pr-str
  (t.pr= "[1 2 3]" (core.pr-str [1 2 3]))
  (t.pr= "1 2 3" (core.pr-str 1 2 3))
  (t.pr= "nil" (core.pr-str nil)))

(deftest map
  (t.pr= [2 3 4] (core.map core.inc [1 2 3])))

(deftest filter
  (t.pr= [2 4 6] (core.filter #(= 0 (% $1 2)) [1 2 3 4 5 6]))
  (t.pr= [] (core.filter #(= 0 (% $1 2)) nil)))

(deftest identity
  (t.= :hello (core.identity :hello) "returns what you give it")
  (t.= nil (core.identity) "no arg returns nil"))

(deftest keys
  (t.pr= [] (core.keys nil) "nil is empty")
  (t.pr= [] (core.keys {}) "empty is empty")
  (t.pr= [:a :b] (core.keys {:a 1 :b 2}) "simple use"))

(deftest vals
  (t.pr= [] (core.vals nil) "nil is empty")
  (t.pr= [] (core.vals {}) "empty is empty")
  (t.pr= [1 2] (core.vals {:a 1 :b 2}) "simple use"))

(deftest kv-pairs
  (t.pr= [] (core.kv-pairs nil) "nil is empty")
  (t.pr= [] (core.kv-pairs {}) "empty is empty")
  (t.pr= [[:a 1] [:b 2]] (core.kv-pairs {:a 1 :b 2}) "simple table")
  (t.pr= [[1 :a] [2 :b]] (core.kv-pairs [:a :b]) "sequential works but is weird"))

(deftest concat
  (let [orig [1 2 3]]
    (t.pr= [1 2 3 4 5 6] (core.concat orig [4 5 6]) "table has been concatenated")
    (t.pr= [4 5 6 1 2 3] (core.concat [4 5 6] orig) "order is important")
    (t.pr= [1 2 3] orig "original hasn't been modified")))

(deftest count
  (t.= 3 (core.count [1 2 3]) "three values")
  (t.= 0 (core.count []) "empty")
  (t.= 0 (core.count nil) "nil")
  (t.= 0 (core.count nil) "no arg")
  (t.= 3 (core.count [1 nil 3]) "nil gap")
  (t.= 4 (core.count [nil nil nil :a]) "mostly nils")
  (t.= 3 (core.count "foo") "strings")
  (t.= 0 (core.count "") "empty strings")
  (t.= 0 (core.count {:a 1 :b 2}) "associative doesn't work"))

(deftest merge
  (t.pr= {:a 1 :b 2} (core.merge {} {:a 1} {:b 2}) "simple maps")
  (t.pr= {} (core.merge) "always start with an empty table")
  (t.pr= {:a 1} (core.merge nil {:a 1}) "into nil")
  (t.pr= {:a 1 :c 3} (core.merge {:a 1} nil {:c 3}) "nil in the middle"))
