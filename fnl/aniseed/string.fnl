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
        len (a.count xs)]

    (var result [])

    (when (> len 0)
      (for [i 1 len]
        (let [x (. xs i)]
          (-?>> (if
                  (= :string (type x)) x
                  (= nil x) x
                  (a.pr-str x))
                (table.insert result)))))

    (table.concat result sep)))

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

(defn triml [s]
  "Removes whitespace from the left side of string."
  (string.gsub s "^%s*(.-)" "%1"))

(defn trimr [s]
  "Removes whitespace from the right side of string."
  (string.gsub s "(.-)%s*$" "%1"))

(defn trim [s]
  "Removes whitespace from both ends of string."
  (string.gsub s "^%s*(.-)%s*$" "%1"))
