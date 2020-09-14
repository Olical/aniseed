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
        (.. "(require-macros :aniseed.macros)\n" content)
        opts))
    fennel.traceback))

(let [filename (. arg 1)
      (_ok? result) (-> filename
                        (read-file)
                        (compile {:filename filename}))]
  (print result))
