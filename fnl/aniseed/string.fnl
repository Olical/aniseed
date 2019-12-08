(local core (require :aniseed.core))

(fn join [...]
  "(join xs) (join sep xs)
  Joins all items of a table together with an optional separator.
  Separator defaults to an empty string.
  Values that aren't a string or nil will go through aniseed.core.pr-str."
  (let [args [...]
        [sep xs] (if (= 2 (length args))
                   args
                   ["" (core.first args)])]

    (var result "")

    (each [_ x (ipairs xs)]
      (set result
           (.. result
               (if
                 (core.string? x) x
                 (core.nil? x) ""
                 (core.pr-str x)))))

    result))

{:aniseed/module :aniseed.string
 :join join}
