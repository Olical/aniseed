;; Macros for module definition.
;; Can't be compiled to Lua directly.

(local module-sym (gensym))

(fn module [name]
  `(local ,module-sym
     (let [name# ,(tostring name)
           loaded# (. package.loaded name#)]
       (if (and (= :table (type loaded#))
                (. loaded# :aniseed/module)) 
         loaded#
         {:aniseed/module name#}))))

(fn def [name value]
  `(local ,name
     (let [v# ,value]
       (tset ,module-sym ,(tostring name) v#)
       v#)))

(fn defn [name ...]
  `(def ,name (fn ,name ,...)))

(fn export []
  module-sym)

{:module module
 :def def
 :defn defn
 :export export}
