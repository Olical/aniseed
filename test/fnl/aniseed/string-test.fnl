(local str (require :aniseed.string))

{:aniseed/module :aniseed.string-test
 :aniseed/tests
 {:join
  (fn [is]
    (is "foo, bar, baz" (str.join ", " ["foo" "bar" "baz"]))
    (is "foobarbaz" (str.join ["foo" "bar" "baz"])))}}
