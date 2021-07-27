(local syms (setmetatable {} {:__index #(sym $2)}))

(fn table? [x]
  (and (= :table (type x)) x))

(fn empty-table [t]
  (while (> (# t) 0)
    (table.remove t)))

;; copied from fennel.utils.copy
;;   simple table copy
(fn copy [from to]
  (let [to (or to [])]
    (each [k v (pairs (or from []))]
      (tset to k v))
    to))

;; splits a table into two by running p on each key
(fn partition-by-key [p x]
  (let [t {} f {}]
    (each [k v (pairs (or x []))]
      (if (p k)
        (tset t k v)
        (tset f k v)))
    (values t f)))

;; recursively `tostring`s a table, only recursing on a value if it is
;;   a table and *not* a symbol, as symbols should be `tostring`ed
(fn stringify-table [t]
  (collect [k v (pairs t)]
    (values
      (tostring k)
      (if (and (not (sym? v)) (table? v))
        (stringify-table v)
        (tostring v)))))

(fn module-form [ast {: scope : parent : opts : compile1}]
  (let [name-str (-?> (assert-compile
                        (sym? (. ast 2)) "expected module name" ast)
                      tostring)
        all-new-local-fns (stringify-table (or (. ast 3) []))
        (autoloads new-local-fns) (partition-by-key
                                    #(= :autoload $)
                                    all-new-local-fns)
        mod (doto (or (. ast 4) {})
                  (tset :aniseed/module name-str)
                  (tset :aniseed/locals {})
                  (tset :aniseed/local-fns all-new-local-fns))
        locals []]

    (tset scope :module {:locals {} :public {}})

    (when (next new-local-fns)
      (each [f aliases (pairs new-local-fns)]
        (each [alias arg (pairs aliases)]
          (table.insert locals
                        [(sym alias)
                         `(,(sym f) ,arg)]))))

    (when (next autoloads)
      (compile1 `(local ,syms.autoload (. (require :aniseed.autoload) :autoload))
                scope parent opts)

      (each [_ aliases (pairs autoloads)]
        (each [alias arg (pairs aliases)]
          (let [sym-alias (sym alias)]
            (table.insert locals
                          [sym-alias
                           `(autoload ,sym-alias ,arg)])))))

    (table.insert locals
                  [syms.*module*
                   `(let [mod# ,mod]
                      (tset package.loaded ,name-str mod#)
                      mod#)])

    (table.insert locals [syms.*module-name* name-str])

    (when opts.filename
      (table.insert locals [syms.*file* opts.filename]))
    
    (let [names []
          vals []]
      
      (each [_ [k v] (ipairs locals)]
        (table.insert names k)
        (table.insert vals v))

      (empty-table ast)
      (copy [`local `(,(unpack names)) `(values ,(unpack vals))] ast))))

(fn def-form [ast {: scope : parent : opts : compile1 &as state} private? value?]
  (let [name (assert-compile (sym? (. ast 2)) "expected name" ast)
        name-str (tostring name)
        value (assert-compile (or value? (. ast 3)) "expected value" ast)
        mod-scope (if private? :locals :public)]
    (tset scope.module mod-scope name-str value)
    
    (compile1 `(local ,name ,value) scope parent opts)

    (when (not private?)
      (compile1 `(tset ,syms.*module* ,name-str ,name) scope parent opts))
    
    (empty-table ast)
    (copy [`tset syms.*module* :aniseed/locals name-str name] ast)))

(fn defn-form [ast {: scope : parent : opts : compile1 &as state} private?]
  (let [[_ _ args & body] ast
        args (assert-compile (table? (. ast 3)) "expected parameters table" ast)
        body (assert-compile (-?>> (table? body)
                                   (and (< 0 (length body))))
                             "expected body expression" ast)
        fn-ast `(fn ,args)]
    (each [_ stmt (pairs body)]
      (table.insert fn-ast stmt))
    
    (def-form ast state private? fn-ast)))

(fn defonce-form [ast {: scope : parent : opts : compile1 &as state} private?]
  (let [name-str (-?> (assert-compile (. ast 2) "expected name")
                      tostring)
        mod-scope (if private? :locals :public)]
    (if (. scope.module mod-scope name-str)
      (do
        (empty-table ast)
        (copy [`lua syms.nil] ast))
      (def-form ast state private?))))

(fn deftest-form [ast {: scope : parent : opts : compile1 &as state}]
  (let [[_ name & body] ast
        name-str (-?> (assert-compile (. ast 2) "expected name")
                      tostring)
        body (assert-compile (-?>> (table? body)
                                   (and (< 0 (length body))))
                             "expected body expression" ast)
        fn-sym (gensym)
        fn-ast `(fn ,fn-sym [,syms.t])]
    (each [_ stmt (pairs body)]
      (table.insert fn-ast stmt))
    
    (compile1 fn-ast scope parent opts)

    (empty-table ast)
    
    (if (. scope.module :has-tests)
      (copy [`tset syms.*module* :aniseed/tests name-str fn-sym] ast)
      (do
        (tset scope.module :has-tests true)
        (copy [`tset syms.*module* :aniseed/tests {name-str fn-sym}] ast)))))

(fn time-form [ast {: scope : parent : opts : compile1 &as state}]
  (let [[_ & body] ast
        body (assert-compile (-?>> (table? body)
                                   (and (< 0 (length body))))
                             "expected body expression" ast)
        time-fn-sym (. scope.module :time-fn-sym)
        body-ast `(do)]
    (when (not time-fn-sym)
      (set-forcibly! time-fn-sym (gensym))
      (tset scope.module :time-fn-sym time-fn-sym)
      (compile1 `(fn ,time-fn-sym [...]
                   (let [start# (vim.loop.hrtime)
                         result# ...
                         end# (vim.loop.hrtime)]
                     (print (.. "Elapsed time: "
                                (/ (- end# start#) 1000000)
                                " msecs"))
                     result#))
                scope parent opts))

    (each [_ stmt (pairs body)]
      (table.insert body-ast stmt))
      
    (empty-table ast)
    (copy `(,time-fn-sym ,body-ast) ast)))

(fn call [ast scope parent opts compile1]
  (let [symbol (. ast 1)
        state {: scope : parent : compile1
               :opts (doto (copy opts)
                           (tset :tail false))}]

    (match (. ast 1)
      syms.module (module-form ast state)
      syms.def- (def-form ast state true)
      syms.def (def-form ast state false)
      syms.defn- (defn-form ast state true)
      syms.defn (defn-form ast state false)
      syms.defonce- (defonce-form ast state true)
      syms.defonce (defonce-form ast state false)
      syms.deftest (deftest-form ast state)
      syms.time (time-form ast state))))

{: call}
