(local view (require :aniseed.view))

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

(fn reduce [f init xs]
  "Reduce xs into a result by passing each subsequent value into the fn with
  the previous value as the first arg. Starting with init."
  (var result init)
  (each [_ x (ipairs xs)]
    (set result (f result x)))
  result)

;; TODO Implement most loops in terms of this.
(fn run! [f xs]
  "Execute the function (for side effects) for every xs."
  (each [_ x (ipairs xs)]
    (f x)))

(fn concat [...]
  "Concatinats the sequential table arguments together."
  (let [result []]
    (run! (fn [xs]
            (each [_ x (ipairs xs)]
              (table.insert result x)))
      [...])
    result))

(fn inc [n]
  "Increment n by 1."
  (+ n 1))

(fn dec [n]
  "Decrement n by 1."
  (- n 1))

(fn slurp [path]
  "Read the file into a string."
  (match (io.open path "r")
    (nil msg) (print (.. "Could not open file: " msg))
    f (let [content (f:read "*all")]
        (f:close)
        content)))

(fn spit [path content]
  "Spit the string into the file."
  (match (io.open path "w")
    (nil msg) (print (.. "Could not open file: " msg))
    f (do
        (f:write content)
        (f:close)
        nil)))

(fn first [xs]
  (when xs
    (. xs 1)))

(fn second [xs]
  (when xs
    (. xs 2)))

(fn string? [x]
  (= "string" (type x)))

(fn nil? [x]
  (= "nil" (type x)))

(fn table? [x]
  (= "table" (type x)))

(fn pr-str [...]
  (.. (unpack
        (map (fn [x]
               (view x {:one-line true}))
             [...]))))

(fn pr [...]
  (print (pr-str ...)))

{:aniseed/module :aniseed.core
 :filter filter
 :map map
 :run! run!
 :reduce reduce
 :concat concat
 :inc inc
 :dec dec
 :slurp slurp
 :spit spit
 :first first
 :second second
 :string? string?
 :nil? nil?
 :table? table?
 :pr-str pr-str
 :pr pr}
