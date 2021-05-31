(local fennel (require :fennel))

(set fennel.path (.. fennel.path ";fnl/?.fnl"))

(fn read-file [path]
  (let [file (io.open path "rb")
        content (file:read "*a")]
    (file:close)
    content))

(fn compile [content opts]
  (xpcall
    (fn []
      (fennel.compileString
        (.. "(local *file* \"" opts.filename "\")"
            "(require-macros :aniseed.macros)\n" content)
        opts))
    fennel.traceback))

(let [filename (. arg 1)
      (ok? result) (-> filename
                       (read-file)
                       (compile {:filename filename
                                 :compilerEnv false}))]
  (if ok?
    (print result)
    (error result)))
