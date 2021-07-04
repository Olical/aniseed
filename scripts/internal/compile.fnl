;; TODO Maybe this all goes away, just use the CLI for this part?

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
      (fennel.compileString content opts))
    fennel.traceback))

(let [filename (. arg 1)
      (ok? result) (-> filename
                       (read-file)
                       (compile {:filename filename
                                 :plugins ["modules-plugin.fnl"]}))]
  (if ok?
    (print result)
    (error result)))
