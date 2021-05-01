(module aniseed.eval
  {autoload {a aniseed.core
             fs aniseed.fs
             nvim aniseed.nvim
             fennel aniseed.fennel
             compile aniseed.compile}})

(defn str [code opts]
  "Like aniseed.compile/str but uses fennel.eval. Returns the result of
  evaluating the given Fennel code with the Aniseed macros automatically
  equired."
  (local [fnl (fennel.impl)]
    (xpcall
      (fn []
        (-> code
            (compile.macros-prefix)
            (fnl.eval (a.merge {:compiler-env _G} opts))))
      fnl.traceback)))
