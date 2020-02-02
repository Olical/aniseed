(require-macros :aniseed.macros)

(module aniseed.string-test
  {require {str aniseed.string}})

(deftest join
  (t.= "foo, bar, baz" (str.join ", " ["foo" "bar" "baz"]))
  (t.= "foobarbaz" (str.join ["foo" "bar" "baz"]))
  (t.= "foobar" (str.join ["foo" nil "bar"]) "handle nils correctly"))
