(module aniseed.string-test
  {require {str aniseed.string}})

(deftest join
  (t.= "foo, bar, baz" (str.join ", " ["foo" "bar" "baz"]))
  (t.= "foobarbaz" (str.join ["foo" "bar" "baz"]))
  (t.= "foobar" (str.join ["foo" nil "bar"]) "handle nils correctly"))

(deftest split
  (t.pr= [] (str.split "" "[^,]+"))
  (t.pr= ["foo"] (str.split "foo" "[^,]+"))
  (t.pr= ["foo" "bar" "baz"] (str.split "foo,bar,baz" "[^,]+")))
