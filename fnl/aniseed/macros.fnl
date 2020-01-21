;; All of Aniseed's macros in one place.
;; Can't be compiled to Lua directly.

(local module-sym (gensym))

(fn module [name opts]
  (let [res-sym (gensym)]
    `(local ,module-sym
       (let [name# ,(tostring name)
             loaded# (. package.loaded name#)
             ,res-sym (if (and (= :table (type loaded#))
                               (. loaded# :aniseed/module)) 
                        loaded#
                        {})]

         (tset ,res-sym :aniseed/module name#)
         (tset ,res-sym :aniseed/requires {})
         (tset ,res-sym :aniseed/includes {})

         ,(when opts
            (let [cmds []]
              (each [kind bindings (pairs opts)]
                (let [kind-str (tostring kind)]
                  (when (or (= "require" kind-str)
                            (= "include" kind-str))
                    (each [alias module (pairs bindings)]
                      (table.insert
                        cmds
                        `(tset (. ,res-sym ,(.. "aniseed/" kind-str "s"))
                               ,(tostring alias)
                               ,(tostring module)))))))
              cmds))

         ,res-sym))))

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
  module-sym)

{:module module
 :def def
 :defn defn
 :when-not when-not
 :defonce defonce
 :export export}
