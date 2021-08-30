(local fennel (require :fennel))

(set fennel.path (.. fennel.path ";fnl/?.fnl"))
(set fennel.macro-path (.. fennel.macro-path ";fnl/?.fnl"))

(fn read-file [path]
  (let [file (io.open path "rb")
        content (file:read "*a")]
    (file:close)
    content))

(local delete-marker-pat "\n[^\n]-\"ANISEED_DELETE_ME\".-")

(fn compile [content opts]
  (xpcall
    (fn []
      (-> (.. "(local *file* \"" opts.filename "\")"
              "(require-macros :aniseed.macros)\n" content)
          (fennel.compileString opts)
          (string.gsub (.. delete-marker-pat "\n") "\n")
          (string.gsub (.. delete-marker-pat "$") "")))
    fennel.traceback))

(let [filename (. arg 1)
      (ok? result) (-> filename
                       (read-file)
                       (compile {:filename filename
                                 :compilerEnv _G}))]
  (if ok?
    (print result)
    (error result)))
