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

(deftest when-let
  (t.= :empty
       (when-let []
         :empty))
  (t.= :ok
       (when-let [foo :ok]
         foo))
  (t.= nil
       (when-let [foo false]
         :first))
  (t.= :second
       (when-let [foo true
                  bar :second]
         bar))
  (t.= nil
       (when-let [foo true
                  bar nil
                  qux :third]
         bar))
  (t.pr= [:first :second :third]
         (when-let [foo :first
                    bar :second
                    qux :third]
           [foo bar qux])))
