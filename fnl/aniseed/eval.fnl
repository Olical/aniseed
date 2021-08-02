(module aniseed.eval
  {autoload {a aniseed.core
             fs aniseed.fs
             nvim aniseed.nvim
             fennel aniseed.fennel
             compile aniseed.compile}})

(local base-path (-?> (. (debug.getinfo 1 :S) :source)
                      (: :gsub :^. "")
                      (: :gsub (string.gsub *file* :fnl :lua) "")))

(defn str [code opts]
  "Like aniseed.compile/str but uses fennel.eval. Returns the result of
  evaluating the given Fennel code with the Aniseed macros automatically
  equired."
  (let [fnl (fennel.impl)
        plugins ["module-system-plugin.fnl"]
        plugins (icollect [_ plugin (ipairs plugins)]
                  (fnl.dofile (.. base-path plugin)
                              {:env :_COMPILER
                               :useMetadata true}))]
    (xpcall
      (fn []
        (-> code
            (fnl.eval (a.merge {:compiler-env _G : plugins} opts))))
      fnl.traceback)))
