(local test (require :aniseed.test))
(local baz (require :bar.baz))

(fn add [a b]
  (+ a b))

(add 10 20)
{:foo :bar}

(baz.print-msg "Everything's okay!")

{:aniseed/tests
 {:basic-addition
  (fn [is]
    (is (add 10 20) 30))

  :something-that-fails
  (fn [is]
    (is 10 20)
    (is true)
    (is false))

  :something-that-throws
  (fn [is]
    (is (baz.doesnt-exist)))

  :something-that-explains-why
  (fn [is]
    (is 10 20)
    (is 10 21))}}
