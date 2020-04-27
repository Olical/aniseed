(module aniseed.string
  {require {a aniseed.core}})

(defn join [...]
  "(join xs) (join sep xs)
  Joins all items of a table together with an optional separator.
  Separator defaults to an empty string.
  Values that aren't a string or nil will go through aniseed.a.pr-str."
  (let [args [...]
        [sep xs] (if (= 2 (a.count args))
                   args
                   ["" (a.first args)])
        count (a.count xs)]

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
                     (a.string? x) x
                     (a.nil? x) ""
                     (a.pr-str x)))))))

    result))

(defn split [s pat]
  "Split the given string into a sequential table using the pattern."
  (var s s)
  (var acc [])
  (while s
    (let [(start end) (string.find s pat)]
      (if (= :nil (type start))
        (do
          (table.insert acc s)
          (set s nil))
        (do
          (table.insert acc (string.sub s 1 (- start 1)))
          (set s (string.sub s (+ end 1)))))))
  acc)
