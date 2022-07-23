(module aniseed.macros-test
  {autoload {{: identity} aniseed.core}})

(deftest defonce
  (set *module*.foo nil)

  (var calls 0)
  (fn inc []
    (set calls (+ calls 1))
    :ok)
  (t.= 0 calls)
  (defonce foo (inc))
  (t.= 1 calls)
  (defonce foo (inc))
  (t.= 1 calls)

  (t.= :destructure-require (identity :destructure-require)))

(deftest if-let
  (t.= :ok
       (if-let [foo :ok]
         foo
         :nope))
  (t.= :nope
       (if-let [foo false]
         :first
         :nope))
  (t.= :yes
       (if-let [{: a} {:a 1}]
         :yes
         :no))
  (t.= :no
       (if-let [{: a} nil]
         :yes
         :no)))

(deftest when-let
  (t.= :ok
       (when-let [foo :ok]
         foo))
  (t.= nil
       (when-let [foo false]
         :first))
  (t.= :yarp
       (when-let [(ok? val) (pcall #:yarp)]
         val))
  (t.= nil
       (when-let [(ok? val) (pcall #(error :narp))]
         val)))
