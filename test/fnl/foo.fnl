(local test (require :aniseed.test))
(local baz (require :bar.baz))

(fn add [a b]
  (+ a b))

(add 10 20)
{:foo :bar}

(test.define
  :basic-addition
  (fn [is]
    (is (add 10 20) 30)))

(test.define
  :something-that-fails
  (fn [is]
    (is 10 20)
    (is true)
    (is false)))

(test.define
  :something-that-throws
  (fn [is]
    (is (baz.doesnt-exist))))

(test.define
  :something-that-explains-why
  (fn [is]
    (is 10 20)
    (is 10 21)))

(test.run)

(baz.print-msg "Everything's okay!")
