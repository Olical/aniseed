(module aniseed.fs-test
  {autoload {fs aniseed.fs}})

(deftest basename
  (t.= "foo" (fs.basename "foo/bar.fnl")))

(deftest path-sep
  (t.= "/" fs.path-sep))

(deftest macro-file-path?
  (t.= true (fs.macro-file-path? "macros.fnl"))
  (t.= true (fs.macro-file-path? "init-macros.fnl"))
  (t.= true (fs.macro-file-path? "macro.fnl"))
  (t.= false (fs.macro-file-path? "macron.fnl"))
  (t.= false (fs.macro-file-path? "macro-thing.fnl"))
  (t.= false (fs.macro-file-path? "macros-things.fnl")))
