(module aniseed.core-test
  {autoload {a aniseed.core}})

(deftest rand
  (t.ok? (not (= (a.rand) (a.rand))))
  (t.ok? (= :number (type (a.rand)))))

(deftest first
  (t.= 1 (a.first [1 2 3]) "1 is first")
  (t.= nil (a.first nil) "first of nil is nil"))

(deftest last
  (t.= 3 (a.last [1 2 3]) "3 is last")
  (t.= nil (a.last nil) "last of nil is nil"))

(deftest butlast
  (t.pr= [] (a.butlast nil) "nothing is empty")
  (t.pr= [] (a.butlast []) "empty is empty")
  (t.pr= [] (a.butlast [1]) "one item is empty")
  (t.pr= [1 2] (a.butlast [1 2 3]) "more than one works"))

(deftest rest
  (t.pr= [] (a.rest nil) "nothing is empty")
  (t.pr= [] (a.rest []) "empty is empty")
  (t.pr= [] (a.rest [1]) "one item is empty")
  (t.pr= [2 3] (a.rest [1 2 3]) "more than one works"))

(deftest second
  (t.= nil (a.second []) "nil when empty")
  (t.= nil (a.second nil) "nil when nil")
  (t.= nil (a.second [1 nil 3]) "nil when the second item is actually nil")
  (t.= 2 (a.second [1 2 3]) "two when the second item is two"))

(deftest string?
  (t.= true (a.string? "foo"))
  (t.= false (a.string? nil))
  (t.= false (a.string? 10)))

(deftest nil?
  (t.= false (a.nil? "foo"))
  (t.= true (a.nil? nil))
  (t.= false (a.nil? 10)))

(deftest some
  (t.= nil (a.some #(and (> $1 5) $1) [1 2 3]) "nil when nothing matches")
  (t.= 3 (a.some #(and (> $1 2) $1) [1 2 3]) "the value when something matches")
  (t.= 3 (a.some #(and $1 (> $1 2) $1) [nil 1 nil 2 nil 3 nil]) "handles nils"))

(deftest inc
  (t.= 2 (a.inc 1))
  (t.= -4 (a.inc -5)))

(deftest dec
  (t.= 1 (a.dec 2))
  (t.= -6 (a.dec -5)))

(deftest even?
  (t.= true (a.even? 2))
  (t.= false (a.even? 3)))

(deftest odd?
  (t.= false (a.odd? 2))
  (t.= true (a.odd? 3)))

(defn- sort [t]
  (table.sort
    t
    (fn [x y]
      (if (= :table (type x))
        (< (a.first x) (a.first y))
        (< x y))))
  t)

(deftest keys
  (t.pr= [] (a.keys nil) "nil is empty")
  (t.pr= [] (a.keys {}) "empty is empty")
  (t.pr= [:a :b] (sort (a.keys {:a 2 :b 2})) "simple use"))

(deftest vals
  (t.pr= [] (a.vals nil) "nil is empty")
  (t.pr= [] (a.vals {}) "empty is empty")
  (t.pr= [1 2] (sort (a.vals {:a 1 :b 2})) "simple use"))

(deftest kv-pairs
  (t.pr= [] (a.kv-pairs nil) "nil is empty")
  (t.pr= [] (a.kv-pairs {}) "empty is empty")
  (t.pr= [[:a 1] [:b 2]] (sort (a.kv-pairs {:a 1 :b 2})) "simple table")
  (t.pr= [[1 :a] [2 :b]] (sort (a.kv-pairs [:a :b])) "sequential works but is weird"))

(deftest pr-str
  (t.pr= "[1 2 3]" (a.pr-str [1 2 3]))
  (t.pr= "1 2 3" (a.pr-str 1 2 3))
  (t.pr= "nil" (a.pr-str nil)))

(deftest str
  (t.pr= "" (a.str))
  (t.pr= "" (a.str ""))
  (t.pr= "" (a.str nil))
  (t.pr= "abc" (a.str "abc"))
  (t.pr= "abc" (a.str "a" "b" "c"))
  (t.pr= "{:a \"abc\"}" (a.str {:a :abc}))
  (t.pr= "[1 2 3]abc" (a.str [1 2 3] "a" "bc")))

(deftest map
  (t.pr= [2 3 4] (a.map a.inc [1 2 3])))

(deftest map-indexed
  (t.pr= [[2 :a] [3 :b]]
         (a.map-indexed
           (fn [[k v]]
             [(a.inc k) v])
           [:a :b])
         "incrementing the index"))

(deftest complement
  (t.= true ((a.complement (fn [] false))))
  (t.= false ((a.complement (fn [] true)))))

(deftest filter
  (t.pr= [2 4 6] (a.filter #(= 0 (% $1 2)) [1 2 3 4 5 6]))
  (t.pr= [] (a.filter #(= 0 (% $1 2)) nil)))

(deftest remove
  (t.pr= [1 3 5] (a.remove #(= 0 (% $1 2)) [1 2 3 4 5 6]))
  (t.pr= [] (a.remove #(= 0 (% $1 2)) nil)))

(deftest identity
  (t.= :hello (a.identity :hello) "returns what you give it")
  (t.= nil (a.identity) "no arg returns nil"))

(deftest concat
  (let [orig [1 2 3]]
    (t.pr= [1 2 3 4 5 6] (a.concat orig [4 5 6]) "table has been concatenated")
    (t.pr= [4 5 6 1 2 3] (a.concat [4 5 6] orig) "order is important")
    (t.pr= [1 2 3] orig "original hasn't been modified")))

(deftest mapcat
  (t.pr= [1 :x 2 :x 3 :x] (a.mapcat (fn [n] [n :x]) [1 2 3]) "simple list"))

(deftest count
  (t.= 3 (a.count [1 2 3]) "three values")
  (t.= 0 (a.count []) "empty")
  (t.= 0 (a.count nil) "nil")
  (t.= 0 (a.count nil) "no arg")
  (t.= 3 (a.count [1 nil 3]) "nil gap")
  (t.= 4 (a.count [nil nil nil :a]) "mostly nils")
  (t.= 3 (a.count "foo") "strings")
  (t.= 0 (a.count "") "empty strings")
  (t.= 2 (a.count {:a 1 :b 2}) "associative also works"))

(deftest empty?
  (t.= true (a.empty? []) "empty table")
  (t.= false (a.empty? [1]) "full table")
  (t.= true (a.empty? "") "empty string")
  (t.= false (a.empty? "a") "full string"))

(deftest merge
  (t.pr= {:a 1 :b 2} (a.merge {} {:a 1} {:b 2}) "simple maps")
  (t.pr= {} (a.merge) "always start with an empty table")
  (t.pr= {:a 1} (a.merge nil {:a 1}) "into nil")
  (t.pr= {:a 1 :c 3} (a.merge {:a 1} nil {:c 3}) "nil in the middle"))

(deftest merge!
  (let [result {:c 3}]
    (t.pr= {:a 1 :b 2 :c 3} (a.merge! result {:a 1} {:b 2}) "simple maps")
    (t.pr= {:a 1 :b 2 :c 3} result "the bang version side effects")))

(deftest select-keys
  (t.pr= {} (a.select-keys nil [:a :b]) "no table")
  (t.pr= {} (a.select-keys {} [:a :b]) "empty table")
  (t.pr= {} (a.select-keys {:a 1 :b 2} nil) "no keys")
  (t.pr= {} (a.select-keys nil nil) "nothing")
  (t.pr= {:a 1 :c 3} (a.select-keys {:a 1 :b 2 :c 3} [:a :c])
         "simple table and keys"))

(deftest get
  (t.= nil (a.get nil :a) "from nothing is nothing")
  (t.= nil (a.get {:a 1} nil) "nothing from something is nothing")
  (t.= 10 (a.get nil nil 10) "just a default returns a default")
  (t.= nil (a.get {:a 1} :b) "a missing key is nothing")
  (t.= 2 (a.get {:a 1} :b 2) "defaults replace missing")
  (t.= 1 (a.get {:a 1} :a) "results match")
  (t.= 1 (a.get {:a 1} :a 2) "results match (even with default)")
  (t.= :b (a.get [:a :b] 2) "sequential tables work too"))

(deftest get-in
  (t.= nil (a.get-in nil [:a]) "something from nil is nil")
  (t.pr= {:a 1} (a.get-in {:a 1} [])
         "empty path is idempotent")
  (t.= 10 (a.get-in {:a {:b 10 :c 20}} [:a :b]) "two levels")
  (t.= 5 (a.get-in {:a {:b 10 :c 20}} [:a :d] 5) "default"))

(deftest assoc
  (t.pr= {} (a.assoc nil nil nil) "3x nil is an empty map")
  (t.pr= {} (a.assoc nil :a nil) "setting to nil is noop")
  (t.pr= {} (a.assoc nil nil :a) "nil key is noop")
  (t.pr= {:a 1} (a.assoc nil :a 1) "from nothing to one key")
  (t.pr= [:a] (a.assoc nil 1 :a) "sequential")
  (t.pr= {:a 1 :b 2} (a.assoc {:a 1} :b 2) "adding to existing")
  (t.pr= {:a 1 :b 2 :c 3} (a.assoc {:a 1} :b 2 :c 3) "multi arg")
  (t.pr= {:a 1 :b 2 :c 3 :d 4} (a.assoc {:a 1} :b 2 :c 3 :d 4) "more multi arg")
  (let [(ok? msg) (pcall #(a.assoc {:a 1} :b 2 :c))]
    (t.= false ok? "uneven args - ok?")
    (t.= "expects even number"
         (msg:match "expects even number") "uneven args - msg")))

(deftest assoc-in
  (t.pr= {} (a.assoc-in nil nil nil) "empty as possible")
  (t.pr= {} (a.assoc-in nil [] nil) "empty path, nothing else")
  (t.pr= {} (a.assoc-in nil [] 2) "empty path and a value")
  (t.pr= {:a 1} (a.assoc-in {:a 1} [] 2)
         "empty path, base table and a value")
  (t.pr= {:a 1 :b 2} (a.assoc-in {:a 1} [:b] 2)
         "simple one path segment")
  (t.pr= {:a 1 :b {:c 2}} (a.assoc-in {:a 1} [:b :c] 2)
         "two levels from base")
  (t.pr= {:b {:c 2}} (a.assoc-in nil [:b :c] 2)
         "two levels from nothing")
  (t.pr= {:a {:b [:c]}} (a.assoc-in nil [:a :b 1] :c)
         "mixing associative and sequential"))

(deftest update
  (t.pr= {:foo 2} (a.update {:foo 1} :foo a.inc) "increment a value"))

(deftest update-in
  (t.pr= {:foo {:bar 2}}
         (a.update-in {:foo {:bar 1}} [:foo :bar] a.inc)
         "increment a value"))

(deftest constantly
  (let [f (a.constantly :foo)]
    (t.= :foo (f))
    (t.= :foo (f :bar))))
