(module aniseed.string-test
  {autoload {str aniseed.string}})

(deftest join
  (t.= "foo, bar, baz" (str.join ", " ["foo" "bar" "baz"]))
  (t.= "foobarbaz" (str.join ["foo" "bar" "baz"]))
  (t.= "foobar" (str.join ["foo" nil "bar"]) "handle nils correctly"))

(deftest split
  (t.pr= [""] (str.split "" ","))
  (t.pr= ["foo"] (str.split "foo" ","))
  (t.pr= ["foo" "bar" "baz"] (str.split "foo,bar,baz" ","))
  (t.pr= ["foo" "" "bar"] (str.split "foo,,bar" ","))
  (t.pr= ["foo" "" "" "bar"] (str.split "foo,,,bar" ","))
  (t.pr= ["foo" "baz"] (str.split "foobarbaz" "bar")))

(deftest blank?
  (t.ok? (str.blank? nil))
  (t.ok? (str.blank? ""))
  (t.ok? (str.blank? " "))
  (t.ok? (str.blank? "   "))
  (t.ok? (str.blank? "   \n \n  "))
  (t.ok? (not (str.blank? "   \n . \n  "))))

(deftest triml
  (t.= "" (str.triml ""))
  (t.= "foo" (str.triml "foo"))
  (t.= "foo" (str.triml "    foo"))
  (t.= "foo" (str.triml "  \n  foo"))
  (t.= "foo  " (str.triml "  \n  foo  ")))

(deftest trimr
  (t.= "" (str.trimr ""))
  (t.= "foo" (str.trimr "foo"))
  (t.= "foo" (str.trimr "foo    "))
  (t.= "foo" (str.trimr "foo  \n  "))
  (t.= "  foo" (str.trimr "  foo  \n  ")))

(deftest trim
  (t.= "" (str.trim ""))
  (t.= "foo" (str.trim "foo"))
  (t.= "foo" (str.trim " \n foo \n \n    ") "basic")
  (t.= "" (str.trim "           ") "just whitespace"))
