(fn filter [f xs]
  "Filter xs down to a new sequential table containing every value that (f x) returned true for."
  (let [result []]
    (each [_ x (ipairs xs)]
      (when (f x)
        (table.insert result x)))
    result))

(fn map [f xs]
  "Map xs to a new sequential table by calling (f x) on each item."
  (let [result []]
    (each [_ x (ipairs xs)]
      (table.insert result (f x)))
    result))

(fn inc [n]
  (+ n 1))

(fn dec [n]
  (- n 1))

(fn slurp [path]
  (match (io.open path "r")
    (nil msg) (print (.. "Could not open file: " msg))
    f (let [content (f.read f "*all")]
        (f.close f)
        content)))

(fn spit [path content]
  (match (io.open path "w")
    (nil msg) (print (.. "Could not open file: " msg))
    f (do
        (f.write f content)
        (f.close f)
        nil)))

{:filter filter
 :map map
 :inc inc
 :dec dec
 :slurp slurp
 :spit spit}
