(module aniseed.string
  {require {a aniseed.core}})

(defn join [...]
  "(join xs) (join sep xs)
  Joins all items of a table together with an optional separator.
  Separator defaults to an empty string.
  Values that aren't a string or nil will go through aniseed.core/pr-str."
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
  (var done? false)
  (var acc [])
  (var index 1)
  (while (not done?)
    (let [(start end) (string.find s pat index)]
      (if (= :nil (type start))
        (do
          (table.insert acc (string.sub s index))
          (set done? true))
        (do
          (table.insert acc (string.sub s index (- start 1)))
          (set index (+ end 1))))))
  acc)

(defn blank? [s]
  "Check if the string is nil, empty or only whitespace."
  (or (a.empty? s)
      (not (string.find s "[^%s]"))))
