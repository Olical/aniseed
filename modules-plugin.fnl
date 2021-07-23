;; TODO
;; *file*
;; (module...)
;; autoload
;; def, defn, defn-, defonce, defonce-, time, deftest

(local root-module-sym (sym :module))
(local def-private-sym (sym :def-))
(local module-sym (sym :*module*))
(local module-name-sym (sym :*module-name*))
(local black-hole-sym (sym :_))

(fn table? [x]
  (= :table (type x)))

(fn empty-table [t]
  (while (> (# t) 0)
    (table.remove t)) )

(fn module-form [ast scope]
  (let [[_module name new-local-fns initial-mod] ast
        name-str (tostring name)
        existing-mod (. package.loaded name-str)
        mod (or existing-mod
                initial-mod
                {:aniseed/module name-str
                 :aniseed/locals {}
                 :aniseed/local-fns new-local-fns})
        locals []]

    ;; Stringify the keys and values of new-local-fns.
    (when (table? new-local-fns)
      (each [f aliases (pairs new-local-fns)]
        (each [alias arg (pairs aliases)]
          (tset aliases alias nil)
          (tset aliases (tostring alias) (tostring arg)))))

    ;; Sync new-local-fns into local-fns if the module is loaded.
    ;; This is only used when reloading a module at runtime.
    (when (and existing-mod new-local-fns)
      (each [k v (pairs new-local-fns)]
        (tset (. existing-mod :aniseed/local-fns) k v)))

    (empty-table ast)

    ;; package.loaded[module-name] = module
    (table.insert
      locals
      [black-hole-sym
       `(tset package.loaded ,name-str ,mod)])

    ;; *module-name*
    (table.insert locals [module-name-sym name-str])

    ;; *module*
    (table.insert locals [module-sym `(. package.loaded ,name-str)])

    ;; local-fns -> local definitions
    (when (table? new-local-fns)
      (each [f aliases (pairs new-local-fns)]
        (each [alias arg (pairs aliases)]
          (table.insert
            locals
            [(sym alias)
             `(,f ,arg)]))))

    ;; Now we build the AST from the locals table.
    (let [names []
          vals []]

      ;; (<local> ...)
      (table.insert ast `local)

      ;; Split all the locals pairs into the names and vals tables.
      (each [_ [k v] (ipairs locals)]
        (table.insert names k)
        (table.insert vals v))

      ;; Then we unpack those tables into our AST.

      ;; (local <(xk yk zk)> ...)
      (table.insert ast (list (unpack names)))

      ;; (local ... <(xv yv zv)>)
      (table.insert ast (list `values (unpack vals))))))

(fn def-private-form [ast scope]
  (let [[_def- name value] ast]
    (empty-table ast)
    (table.insert ast `local)
    (table.insert ast name)
    (table.insert
      ast
      `(let [v# ,value]
         (tset
           (. ,module-sym :aniseed/locals)
           ,(tostring name)
           v#)
         #v))))

(fn call [ast scope]
  (let [head (. ast 1)]
    (if
      ;; (module ...)
      (= root-module-sym head) (module-form ast scope)

      ;; (def- ...)
      (= def-private-sym head) (def-private-form ast scope))))

{:call call}
