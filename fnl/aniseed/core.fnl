(module aniseed.core
  {autoload {view aniseed.view}})

;; Useful to have this set by someone.
(math.randomseed (os.time))

(defn rand [n]
  (* (math.random) (or n 1)))

(defn string? [x]
  (= "string" (type x)))

(defn nil? [x]
  (= nil x))

(defn table? [x]
  (= "table" (type x)))

(defn count [xs]
  (if
    (table? xs) (table.maxn xs)
    (not xs) 0
    (length xs)))

(defn empty? [xs]
  (= 0 (count xs)))

(defn first [xs]
  (when xs
    (. xs 1)))

(defn second [xs]
  (when xs
    (. xs 2)))

(defn last [xs]
  (when xs
    (. xs (count xs))))

(defn inc [n]
  "Increment n by 1."
  (+ n 1))

(defn dec [n]
  "Decrement n by 1."
  (- n 1))

(defn even? [n]
  (= (% n 2) 0))

(defn odd? [n]
  (not (even? n)))

(defn keys [t]
  "Get all keys of a table."
  (let [result []]
    (when t
      (each [k _ (pairs t)]
        (table.insert result k)))
    result))

(defn vals [t]
  "Get all values of a table."
  (let [result []]
    (when t
      (each [_ v (pairs t)]
        (table.insert result v)))
    result))

(defn kv-pairs [t]
  "Get all keys and values of a table zipped up in pairs."
  (let [result []]
    (when t
      (each [k v (pairs t)]
        (table.insert result [k v])))
    result))

(defn run! [f xs]
  "Execute the function (for side effects) for every xs."
  (when xs
    (let [nxs (count xs)]
      (when (> nxs 0)
        (for [i 1 nxs]
          (f (. xs i)))))))

(defn filter [f xs]
  "Filter xs down to a new sequential table containing every value that (f x) returned true for."
  (let [result []]
    (run!
      (fn [x]
        (when (f x)
          (table.insert result x)))
      xs)
    result))

(defn map [f xs]
  "Map xs to a new sequential table by calling (f x) on each item."
  (let [result []]
    (run!
      (fn [x]
        (let [mapped (f x)]
          (table.insert
            result
            (if (= 0 (select "#" mapped))
              nil
              mapped))))
      xs)
    result))

(defn map-indexed [f xs]
  "Map xs to a new sequential table by calling (f [k v]) on each item. "
  (map f (kv-pairs xs)))

(defn identity [x]
  "Returns what you pass it."
  x)

(defn reduce [f init xs]
  "Reduce xs into a result by passing each subsequent value into the fn with
  the previous value as the first arg. Starting with init."
  (var result init)
  (run!
    (fn [x]
      (set result (f result x)))
    xs)
  result)

(defn some [f xs]
  "Return the first truthy result from (f x) or nil."
  (var result nil)
  (var n 1)
  (while (and (nil? result) (<= n (count xs)))
    (let [candidate (f (. xs n))]
      (when candidate
        (set result candidate))
      (set n (inc n))))
  result)

(defn butlast [xs]
  (let [total (count xs)]
    (->> (kv-pairs xs)
         (filter
           (fn [[n v]]
             (not= n total)))
         (map second))))

(defn rest [xs]
  (->> (kv-pairs xs)
       (filter
         (fn [[n v]]
           (not= n 1)))
       (map second)))

(defn concat [...]
  "Concatenates the sequential table arguments together."
  (let [result []]
    (run! (fn [xs]
            (run!
              (fn [x]
                (table.insert result x))
              xs))
      [...])
    result))

(defn mapcat [f xs]
  (concat (unpack (map f xs))))

(defn pr-str [...]
  (let [s (table.concat
            (map (fn [x]
                   (view.serialise x {:one-line true}))
                 [...])
            " ")]
    (if (or (nil? s) (= "" s))
      "nil"
      s)))

(defn str [...]
  (->> [...]
       (map
         (fn [s]
           (if (string? s)
             s
             (pr-str s))))
       (reduce
         (fn [acc s]
           (.. acc s))
         "")))

(defn println [...]
  (->> [...]
       (map
         (fn [s]
           (if (string? s)
             s
             (pr-str s))))
       (map-indexed
         (fn [[i s]]
           (if (= 1 i)
             s
             (.. " " s))))
       (reduce
         (fn [acc s]
           (.. acc s))
         "")
       print))

(defn pr [...]
  (println (pr-str ...)))

(defn slurp [path silent?]
  "Read the file into a string."
  (match (io.open path "r")
    (nil msg) nil
    f (let [content (f:read "*all")]
        (f:close)
        content)))

(defn spit [path content]
  "Spit the string into the file."
  (match (io.open path "w")
    (nil msg) (error (.. "Could not open file: " msg))
    f (do
        (f:write content)
        (f:close)
        nil)))

(defn merge! [base ...]
  (reduce
    (fn [acc m]
      (when m
        (each [k v (pairs m)]
          (tset acc k v)))
      acc)
    (or base {})
    [...]))

(defn merge [...]
  (merge! {} ...))

(defn select-keys [t ks]
  (if (and t ks)
    (reduce
      (fn [acc k]
        (when k
          (tset acc k (. t k)))
        acc)
      {}
      ks)
    {}))

(defn get [t k d]
  (let [res (when (table? t)
              (let [val (. t k)]
                (when (not (nil? val))
                  val)))]
    (if (nil? res)
      d
      res)))

(defn get-in [t ks d]
  (let [res (reduce
              (fn [acc k]
                (when (table? acc)
                  (get acc k)))
              t ks)]
    (if (nil? res)
      d
      res)))

(defn assoc [t ...]
  (let [[k v & xs] [...]
        rem (count xs)
        t (or t {})]

    (when (odd? rem)
      (error "assoc expects even number of arguments after table, found odd number"))

    (when (not (nil? k))
      (tset t k v))

    (when (> rem 0)
      (assoc t (unpack xs)))

    t))

(defn assoc-in [t ks v]
  (let [path (butlast ks)
        final (last ks)
        t (or t {})]
    (assoc (reduce
             (fn [acc k]
               (let [step (get acc k)]
                 (if (nil? step)
                   (get (assoc acc k {}) k)
                   step)))
             t
             path)
           final
           v)
    t))

(defn update [t k f]
  (assoc t k (f (get t k))))

(defn update-in [t ks f]
  (assoc-in t ks (f (get-in t ks))))

(defn constantly [v]
  (fn [] v))
