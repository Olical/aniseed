(local view (require :aniseed.view))

(fn first [xs]
  (when xs
    (. xs 1)))

(fn second [xs]
  (when xs
    (. xs 2)))

(fn string? [x]
  (= "string" (type x)))

(fn nil? [x]
  (= nil x))

(fn table? [x]
  (= "table" (type x)))

(fn inc [n]
  "Increment n by 1."
  (+ n 1))

(fn dec [n]
  "Decrement n by 1."
  (- n 1))

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

(fn identity [x]
  "Returns what you pass it."
  x)

(fn keys [t]
  "Get all keys of a table."
  (let [result []]
    (each [k _ (pairs t)]
      (table.insert result k))
    result))

(fn vals [t]
  "Get all values of a table."
  (let [result []]
    (each [_ v (pairs t)]
      (table.insert result v))
    result))

(fn reduce [f init xs]
  "Reduce xs into a result by passing each subsequent value into the fn with
  the previous value as the first arg. Starting with init."
  (var result init)
  (each [_ x (ipairs xs)]
    (set result (f result x)))
  result)

(fn some [f xs]
  "Return the first truthy result from (f x) or nil."
  (var result nil)
  (var n 1)
  (while (and (not result) (<= n (length xs)))
    (let [candidate (f (. xs n))]
      (when candidate
        (set result candidate))
      (set n (inc n))))
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

(fn pr-str [...]
  (.. (unpack
        (map (fn [x]
               (view x {:one-line true}))
             [...]))))

(fn pr [...]
  (print (pr-str ...)))

(fn module [name bindings]
  (setmetatable
    bindings
    {:aniseed/module name
     :aniseed/env (getfenv)})
  bindings)

(module
  :aniseed.core
  {:first first
   :second second
   :string? string?
   :nil? nil?
   :table? table?
   :inc inc
   :dec dec
   :filter filter
   :map map
   :identity identity
   :keys keys
   :vals vals
   :run! run!
   :reduce reduce
   :some some
   :concat concat
   :slurp slurp
   :spit spit
   :pr-str pr-str
   :pr pr
   :module module})
