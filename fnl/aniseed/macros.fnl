;; All of Aniseed's macros in one place.
;; Can't be compiled to Lua directly.

;; looks like it's to do with def
;; maybe locals from the end of module too

(local module-sym (gensym))

(fn when-not [pred ...]
  `(when (not ,pred)
     ,...))

(fn module [name opts]
  (if name
    `[(local ,module-sym
        (let [name# ,(tostring name)
              loaded# (. package.loaded name#)]
          (if (and (= :table (type loaded#))
                   (. loaded# :aniseed/module))
            loaded#
            {:aniseed/module name#})))

      ,(let [aliases []
             vals []
             locals (-?> package.loaded
                         (. (tostring name))
                         (. :aniseed/locals))]

         (when opts
           (each [action binds (pairs opts)]
             (each [alias module (pairs binds)]
               (table.insert aliases alias)
               (table.insert vals `(,action ,(tostring module))))))

         (when locals
           (each [alias val (pairs locals)]
             (table.insert aliases (sym alias))
             (table.insert vals `(-> ,module-sym (. :aniseed/locals) (. ,alias)))))

         `(local ,aliases ,vals))]

    `(do
       (var locals# (or (. ,module-sym :aniseed/locals) {}))
       (var done?# false)
       (var n# 1)

       (while (not done?#)
         (let [(name# value#) (debug.getlocal 1 n#)]
           (if name#
             (do
               (set n# (+ n# 1))
               (when-not (string.find name# "^_%d")
                 (tset locals# name# value#)))
             (set done?# true))))

       (tset ,module-sym :aniseed/locals locals#)
       ,module-sym)))

(fn def [name value]
  `(local ,name
     (let [v# ,value]
       (tset ,module-sym ,(tostring name) v#)
       v#)))

(fn defn [name ...]
  `(def ,name (fn ,name ,...)))

(fn defonce [name value]
  `(when-not (. ,module-sym ,(tostring name))
     (def ,name ,value)))

{:when-not when-not
 :module module
 :def def
 :defn defn
 :defonce defonce}
