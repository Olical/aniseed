;; All of Aniseed's macros in one place.
;; Can't be compiled to Lua directly.

(local module-sym (gensym))

;; TODO Add local requires / imports from the args list.
;; I think I need to register what it wants (by name) in the module map.
;; That allows inspection of what's required to allow dynamic evaluation.
;; Goal: Be able to evaluate each form in a file one at a time and have it work.
;; This means module, then defs and have them all work.
(fn module [name ...]
  (let [args [...]]
    `[(local ,module-sym
        (let [name# ,(tostring name)
              loaded# (. package.loaded name#)]
          (if (and (= :table (type loaded#))
                   (. loaded# :aniseed/module)) 
            loaded#
            {:aniseed/module name#})))]))

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
