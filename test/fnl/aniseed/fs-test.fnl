(local fs (require :aniseed.fs))

{:aniseed/module :aniseed.fs-test
 :aniseed/tests
 {:basename
  (fn [t]
    (t.= "foo" (fs.basename "foo/bar.fnl")))}}
