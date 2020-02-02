(require-macros :aniseed.macros)

(module aniseed.compile
  {require {core aniseed.core
            fs aniseed.fs
            nvim aniseed.nvim
            fennel aniseed.fennel}})

(defn str [content opts]
  "Compile some Fennel code as a string into Lua. Maps to fennel.compileString
  with some wrapping, returns an (ok? result) tuple."
  (xpcall
    (fn []
      (fennel.compileString content opts))
    fennel.traceback))

(defn file [src dest opts]
  "Compile the source file into the destination file if the source file was
  modified more recently. Will create any required ancestor directories for the
  destination file to exist."
  (when (or (and (core.table? opts) (. opts :force))
            (> (nvim.fn.getftime src) (nvim.fn.getftime dest)))
    (let [content (core.slurp src)]
      (match (str content {:filename src})
        (false err) (nvim.err_writeln err)
        (true result) (do
                        (-> dest fs.basename fs.mkdirp)
                        (core.spit dest result))))))

(defn glob [src-expr src-dir dest-dir opts]
  "Match all files against the src-expr under the src-dir then compile them
  into the dest-dir as Lua."
  (let [src-dir-len (core.inc (string.len src-dir))
        src-paths (->> (nvim.fn.globpath src-dir src-expr true true)
                       (core.map (fn [path]
                                   (string.sub path src-dir-len))))]
    (each [_ path (ipairs src-paths)]
      (file (.. src-dir path)
            (string.gsub
              (.. dest-dir path)
              ".fnl$" ".lua")
            opts))))
