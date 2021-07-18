(module aniseed.fs-test
  {autoload {fs aniseed.fs}})

(deftest basename
  (t.= "foo" (fs.basename "foo/bar.fnl")))

(deftest path-sep
  (t.= "/" fs.path-sep))
