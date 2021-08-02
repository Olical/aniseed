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

;; serializes the local-fns table for runtime
(fn view-local-fns [t]
  (let [serialized (copy t)]
    (fn process [f args]
      (if (or (= f :require)
              (= f :autoload)
              (= f :import-macros))
        (collect [bindings module (pairs args)]
          (values (view bindings) (tostring module)))
        (or (= f :include)
            (= f :require-macros))
        (icollect [_ module (pairs args)]
          (tostring module))
        (view args)))

    (each [f args (pairs serialized)]
      (tset serialized f (process f args)))
    serialized))

(fn module-form [ast scope filename compile]
  (let [name-str (-?> (assert-compile (sym? (. ast 2))
                                      "expected name"
                                      ast)
                      (tostring))
        {:include included
         :require required
         :autoload autoloaded
         :import-macros imported-macros
         :require-macros required-macros
         &as new-local-fns} (collect [f args (pairs (or (. ast 3) []))]
                              (values (tostring f) args))
        mod (doto (or (. ast 4) {})
                  (tset :aniseed/module name-str)
                  (tset :aniseed/locals {})
                  (tset :aniseed/local-fns (view-local-fns new-local-fns)))
        locals []]

    (tset scope :module {:locals {} :public {}})

    (when included
      (each [_ module (ipairs included)]
        (compile `(include ,(tostring module)))))

    (when imported-macros
      (each [bindings module (pairs imported-macros)]
        (compile `(import-macros ,bindings ,(tostring module)))))

    (when required-macros
      (each [_ module (ipairs required-macros)]
        (compile `(require-macros ,(tostring module)))))

    (when required
      (each [bindings module (pairs required)]
        (table.insert locals [bindings
                              `(require ,(tostring module))])))

    (when autoloaded
      (compile `(local ,syms.autoload
                       (. (require :aniseed.autoload) :autoload)))

      (each [alias module (pairs autoloaded)]
        (assert-compile (sym? alias)
                        "expected symbol, destructuring not yet supported for `autoload`"
                        alias)
        (table.insert locals [alias
                              `(autoload ,alias ,(tostring module))])))

    (table.insert locals
                  [syms.*module*
                   `(let [mod# ,mod]
                      (tset package.loaded ,name-str mod#)
                      mod#)])

    (table.insert locals [syms.*module-name* name-str])

    (when filename
      (table.insert locals [syms.*file* filename]))
    
    (let [names []
          vals []]
      
      (each [_ [k v] (ipairs locals)]
        (table.insert names k)
        (table.insert vals v))

      (empty-table ast)
      (copy [`local `(,(unpack names)) `(values ,(unpack vals))] ast))))

(fn def-form [ast scope compile private? value?]
  (let [name (assert-compile (sym? (. ast 2)) "expected name" ast)
        name-str (tostring name)
        value (assert-compile (or value? (. ast 3)) "expected value" ast)
        mod-scope (if private? :locals :public)]
    (tset scope.module mod-scope name-str value)
    
    ;; this has been separated into two statements now
    ;;   to support self reference within the value
    (compile `(local ,name nil))
    (compile `(set-forcibly! ,name ,value))

    (when (not private?)
      (compile `(tset ,syms.*module* ,name-str ,name)))
    
    (empty-table ast)
    (copy [`tset syms.*module* :aniseed/locals name-str name] ast)))

(fn defn-form [ast scope compile private?]
  (let [[_ _ args & body] ast
        args (assert-compile (table? (. ast 3))
                             "expected parameters table"
                             ast)
        body (assert-compile (-?>> (table? body)
                                   (and (< 0 (length body))))
                             "expected body expression"
                             ast)
        fn-ast `(fn ,args)]
    (each [_ stmt (pairs body)]
      (table.insert fn-ast stmt))
    
    (def-form ast scope compile private? fn-ast)))

(fn defonce-form [ast scope compile private?]
  (let [name-str (-?> (assert-compile (. ast 2) "expected name" ast)
                      (tostring))
        mod-scope (if private? :locals :public)]
    (if (. scope.module mod-scope name-str)
      (do
        (empty-table ast)
        (copy [`lua syms.nil] ast))
      (def-form ast scope compile private?))))

(fn deftest-form [ast scope compile]
  (let [[_ name & body] ast
        name-str (-?> (assert-compile (. ast 2) "expected name" ast)
                      (tostring))
        body (assert-compile (-?>> (table? body)
                                   (and (< 0 (length body))))
                             "expected body expression"
                             ast)
        fn-sym (gensym)
        fn-ast `(fn ,fn-sym [,syms.t])]
    (each [_ stmt (pairs body)]
      (table.insert fn-ast stmt))
    
    (compile fn-ast)

    (empty-table ast)
    
    (if (. scope.module :has-tests)
      (copy [`tset syms.*module* :aniseed/tests name-str fn-sym] ast)
      (do
        (tset scope.module :has-tests true)
        (copy [`tset syms.*module* :aniseed/tests {name-str fn-sym}] ast)))))

(fn time-form [ast scope compile]
  (let [[_ & body] ast
        body (assert-compile (-?>> (table? body)
                                   (and (< 0 (length body))))
                             "expected body expression"
                             ast)
        time-fn-sym (. scope.module :time-fn-sym)
        body-ast `(do)]
    (when (not time-fn-sym)
      (set-forcibly! time-fn-sym (gensym))
      (tset scope.module :time-fn-sym time-fn-sym)
      (compile `(fn ,time-fn-sym [...]
                   (let [start# (vim.loop.hrtime)
                         result# ...
                         end# (vim.loop.hrtime)]
                     (print (.. "Elapsed time: "
                                (/ (- end# start#) 1000000)
                                " msecs"))
                     result#))))

    (each [_ stmt (pairs body)]
      (table.insert body-ast stmt))
      
    (empty-table ast)
    (copy `(,time-fn-sym ,body-ast) ast)))

(fn call [ast scope parent opts compile1]
  (let [symbol (. ast 1)
        opts (doto (copy opts)
                   (tset :tail false))
        compile (fn [ast] (compile1 ast scope parent opts))]

    (match (. ast 1)
      syms.module (module-form ast scope opts.filename compile)
      syms.def- (def-form ast scope compile true)
      syms.def (def-form ast scope compile false)
      syms.defn- (defn-form ast scope compile true)
      syms.defn (defn-form ast scope compile false)
      syms.defonce- (defonce-form ast scope compile true)
      syms.defonce (defonce-form ast scope compile false)
      syms.deftest (deftest-form ast scope compile)
      syms.time (time-form ast scope compile))))

{: call}
