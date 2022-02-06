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
            (compile.wrap-macros opts)
            (fnl.eval (a.merge {:compilerEnv _G} opts))))
      fnl.traceback)))

(defn- clean-values [vals]
  (a.filter
    (fn [val]
      (if (a.table? val)
        (not= compile.delete-marker (a.first val))
        true))
    vals))

(defn clean-error [err]
  (-> err
      (string.gsub "^%b[string .-%b]:%d+: " "")
      (string.gsub "^Compile error in .-:%d+\n%s+" "")))

(defn repl [opts]
  "Create a new REPL instance which is a function you repeatedly call with more
  code for evaluation. The results of the evaluations are returned in a table."
  (var eval-values nil)
  (let [fnl (fennel.impl)
        opts (or opts {})
        co (coroutine.create
             (fn []
               (fnl.repl
                 (a.merge {:compilerEnv _G
                           :pp a.identity
                           :readChunk coroutine.yield
                           :onValues #(set eval-values (clean-values $1))
                           :onError #((or opts.error-handler
                                          nvim.err_writeln)
                                      (clean-error $2))}
                          opts))))]

    (coroutine.resume co)
    (coroutine.resume co (compile.wrap-macros nil opts))
    (set eval-values nil)

    (fn [code]
      (global ANISEED_STATIC_MODULES false)
      (coroutine.resume co code)
      (let [prev-eval-values eval-values]
        (set eval-values nil)
        prev-eval-values))))
