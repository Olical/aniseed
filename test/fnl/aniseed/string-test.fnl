(local str (require :aniseed.string))

{:aniseed/module :aniseed.string-test
 :aniseed/tests
 {:join
  (fn [t]
    (t.= "foo, bar, baz" (str.join ", " ["foo" "bar" "baz"]))
    (t.= "foobarbaz" (str.join ["foo" "bar" "baz"])))}}
