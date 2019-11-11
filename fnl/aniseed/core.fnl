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

{:filter filter
 :map map}
