(require-macros :aniseed.macros)

(module aniseed.string
  {require {core aniseed.core}})

(defn join [...]
  "(join xs) (join sep xs)
  Joins all items of a table together with an optional separator.
  Separator defaults to an empty string.
  Values that aren't a string or nil will go through aniseed.core.pr-str."
  (let [args [...]
        [sep xs] (if (= 2 (length args))
                   args
                   ["" (core.first args)])
        count (core.count xs)]

    (var result "")

    (when (> count 0)
      (for [i 1 count]
        (let [x (. xs i)]
          (set result
               (.. result
                   (if (= 1 i)
                     ""
                     sep)
                   (if
                     (core.string? x) x
                     (core.nil? x) ""
                     (core.pr-str x)))))))

    result))

(module)
