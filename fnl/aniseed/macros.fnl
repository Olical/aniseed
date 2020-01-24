;; All of Aniseed's macros in one place.
;; Can't be compiled to Lua directly.

(local module-sym (gensym))

(fn module [name new-local-fns]
  `[(local ,module-sym
      (let [name# ,(tostring name)
            loaded# (. package.loaded name#)
            module# (if (= :table (type loaded#)) loaded# {})]
        (tset module# :aniseed/module name#)
        (tset module# :aniseed/locals (or (. module# :aniseed/locals) {}))
        (tset module# :aniseed/local-fns (or (. module# :aniseed/local-fns) {}))
        (tset package.loaded name# module#)
        module#))

    ,(let [aliases []
           vals []
           locals (-?> package.loaded
                       (. (tostring name))
                       (. :aniseed/locals))
           local-fns (or (-?> package.loaded
                              (. (tostring name))
                              (. :aniseed/local-fns))
                         {})]

       (when new-local-fns
         (each [action binds (pairs new-local-fns)]
           (let [action-str (tostring action)
                 current (or (. local-fns action-str) {})]
             (tset local-fns action-str current)
             (each [alias module (pairs binds)]
               (tset current (tostring alias) (tostring module))))))

       (each [action binds (pairs local-fns)]
         (each [alias module (pairs binds)]
           (table.insert aliases (sym alias))
           (table.insert vals `(,(sym action) ,module))))

       (when locals
         (each [alias val (pairs locals)]
           (table.insert aliases (sym alias))
           (table.insert vals `(-> ,module-sym (. :aniseed/locals) (. ,alias)))))

       `(local ,aliases
          (do
            (tset ,module-sym :aniseed/local-fns ,local-fns)
            ,vals)))])

(fn def- [name value]
  `(local ,name
     (let [v# ,value]
       (tset (. ,module-sym :aniseed/locals) ,(tostring name) v#)
       v#)))

(fn def [name value]
  `(def- ,name
     (do
       (let [v# ,value]
         (tset ,module-sym ,(tostring name) v#)
         v#))))

(fn defn- [name ...]
  `(def- ,name (fn ,name ,...)))

(fn defn [name ...]
  `(def ,name (fn ,name ,...)))

(fn defonce- [name value]
  `(when (not (. ,module-sym ,(tostring name)))
     (def- ,name ,value)))

(fn defonce [name value]
  `(when (not (. ,module-sym ,(tostring name)))
     (def ,name ,value)))

{:module module
 :def- def- :def def
 :defn- defn- :defn defn
 :defonce- defonce- :defonce defonce}
