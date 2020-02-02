(module aniseed.fs-test
  {require {fs aniseed.fs}})

(deftest basename
  (t.= "foo" (fs.basename "foo/bar.fnl")))
