(module aniseed.autoload)

(defn autoload [name]
  "Like autoload from Vim Script! A replacement for require that will load the
  module when you first use it. Use it in Aniseed module macros with:

  (module foo {autoload {foo x.y.foo}})

  It's a drop in replacement for require that should speed up your Neovim
  startup dramatically. Only works with table modules, if the module you're
  requiring is a function etc you need to use the normal require."

  (let [res {:aniseed/autoload-enabled? true
             :aniseed/autoload-module false}]

    (fn ensure []
      (if (. res :aniseed/autoload-module)
        (. res :aniseed/autoload-module)
        (let [m (require name)]
          (tset res :aniseed/autoload-module m)
          m)))

    (setmetatable
      res

      {:__call
       (fn [t ...]
         ((ensure) ...))

       :__index
       (fn [t k]
         (. (ensure) k))

       :__newindex
       (fn [t k v]
         (tset (ensure) k v))})))
