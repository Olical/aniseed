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
  (let [fnl (fennel.impl)]
    (xpcall
      (fn []
        (-> code
            (compile.macros-prefix opts)
            (fnl.eval (a.merge {:compilerEnv _G} opts))))
      fnl.traceback)))

(defn repl [opts]
  (var eval-values nil)
  (let [fnl (fennel.impl)
        co (coroutine.create
             (fn []
               (fnl.repl
                 (a.merge {:compilerEnv _G
                           :readChunk coroutine.yield
                           :onValues #(set eval-values $1)
                           :onError #(nvim.err_writeln $2)}
                          opts))))]

    (coroutine.resume co)
    (coroutine.resume co (compile.macros-prefix nil opts))

    (fn [code]
      (coroutine.resume co code)
      (let [prev-eval-values eval-values]
        (set eval-values nil)
        prev-eval-values))))
