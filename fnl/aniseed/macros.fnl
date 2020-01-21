;; All of Aniseed's macros in one place.
;; Can't be compiled to Lua directly.

(local module-sym (gensym))

(fn module [name opts]
  `[(local ,module-sym
      (let [name# ,(tostring name)
            loaded# (. package.loaded name#)]
        (if (and (= :table (type loaded#))
                 (. loaded# :aniseed/module))
          loaded#
          {:aniseed/module name#})))

    ,(let [aliases []
           actions []
           loaded (. package.loaded (tostring name))]

       (when opts
         (each [action binds (pairs opts)]
           (each [alias module (pairs binds)]
             (table.insert aliases alias)
             (table.insert actions `(,action ,(tostring module))))))

       `(local ,aliases ,actions))])

(fn def [name value]
  `(local ,name
     (let [v# ,value]
       (tset ,module-sym ,(tostring name) v#)
       v#)))

(fn defn [name ...]
  `(def ,name (fn ,name ,...)))

(fn when-not [pred ...]
  `(when (not ,pred)
     ,...))

(fn defonce [name value]
  `(when-not (. ,module-sym ,(tostring name))
     (def ,name ,value)))

(fn export []
  `(do
     (var locals# (or (. ,module-sym :aniseed/locals) {}))
     (var done?# false)
     (var n# 1)
     (while (not done?#)
       (let [(name# value#) (debug.getlocal 1 n#)]
         (if name#
           (do
             (set n# (+ n# 1))
             (tset locals# name# value#))
           (set done?# true))))
     (tset ,module-sym :aniseed/locals locals#)
     ,module-sym))

{:module module
 :def def
 :defn defn
 :when-not when-not
 :defonce defonce
 :export export}
