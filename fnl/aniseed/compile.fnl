(module aniseed.compile
  {autoload {a aniseed.core
             fs aniseed.fs
             nvim aniseed.nvim
             fennel aniseed.fennel}})

(defn macros-prefix [code]
  (let [macros-module :aniseed.macros]
    (.. "(require-macros \"" macros-module "\")\n" code)))

(defn str [code opts]
  "Compile some Fennel code as a string into Lua. Maps to fennel.compileString
  with some wrapping, returns an (ok? result) tuple. Automatically requires the
  Aniseed macros."

  (when (and opts opts.on-pre-compile)
    (opts.on-compile))

  (let [fnl (fennel.impl)]
    (xpcall
      (fn []
        (fnl.compileString
          (macros-prefix code)
          (a.merge {:compiler-env _G} opts)))
      fnl.traceback)))

(defn file [src dest opts]
  "Compile the source file into the destination file if the source file was
  modified more recently. Will create any required ancestor directories for the
  destination file to exist."
  (when (or (and (a.table? opts) (. opts :force))
            (> (nvim.fn.getftime src) (nvim.fn.getftime dest)))
    (let [code (a.slurp src)]
      (match (str code {:filename src})
        (false err) (nvim.err_writeln err)
        (true result) (do
                        (-> dest fs.basename fs.mkdirp)
                        (a.spit dest result))))))

(defn glob [src-expr src-dir dest-dir opts]
  "Match all files against the src-expr under the src-dir then compile them
  into the dest-dir as Lua."
  (let [src-dir-len (a.inc (string.len src-dir))
        src-paths (->> (nvim.fn.globpath src-dir src-expr true true)
                       (a.map (fn [path]
                                (string.sub path src-dir-len))))]
    (each [_ path (ipairs src-paths)]
      (when (or (a.get opts :include-macros-suffix?)
                (not (string.match path "macros.fnl$")))
        (file (.. src-dir path)
              (string.gsub
                (.. dest-dir path)
                ".fnl$" ".lua")
              opts)))))
