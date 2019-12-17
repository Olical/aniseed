(local fs (require :aniseed.fs))

{:aniseed/module :aniseed.fs-test
 :aniseed/tests
 {:basename
  (fn [is]
    (is "foo" (fs.basename "foo/bar.fnl")))}}
