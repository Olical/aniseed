(module aniseed.autoload)

(defn autoload [name]
  "Like autoload from Vim Script! A replacement for require that will load the
  module when you first use it. Use it in Aniseed module macros with:

  (module foo {autoload {foo x.y.foo}})

  It's a drop in replacement for require that should speed up your Neovim
  startup dramatically. Only works with table modules, if the module you're
  requiring is a function etc you need to use the normal require."

  (setmetatable
    {:aniseed/autoload? true}

    {:__index
     (fn [t k]
       (. (require name) k))

     :__newindex
     (fn [t k v]
       (tset (require name) k v))}))
