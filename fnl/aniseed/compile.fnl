(module aniseed.compile
  {autoload {a aniseed.core
             fs aniseed.fs
             nvim aniseed.nvim
             fennel aniseed.fennel}})

(local base-path (-?> (. (debug.getinfo 1 :S) :source)
                      (: :gsub :^. "")
                      (: :gsub (string.gsub *file* :fnl :lua) "")))

(defn str [code opts]
  "Compile some Fennel code as a string into Lua. Maps to
  fennel.compileString with some wrapping, returns an (ok? result)
  tuple. Automatically requires the Aniseed macros."

  (let [fnl (fennel.impl)
        plugins ["module-system-plugin.fnl"]
        plugins (icollect [_ plugin (ipairs plugins)]
                  (fnl.dofile (.. base-path plugin)
                              {:env :_COMPILER
                               :useMetadata true}))]
    (xpcall
      #(fnl.compileString
         code
         (a.merge {:allowedGlobals false : plugins} opts))
      fnl.traceback)))

(defn file [src dest]
  "Compile the source file into the destination file. Will create any
  required ancestor directories for the destination file to exist."
  (let [code (a.slurp src)]
    (match (str code {:filename src})
      (false err) (nvim.err_writeln err)
      (true result) (do
                      (-> dest fs.basename fs.mkdirp)
                      (a.spit dest result)))))

(defn glob [src-expr src-dir dest-dir]
  "Match all files against the src-expr under the src-dir then compile
  them into the dest-dir as Lua."
  (each [_ path (ipairs (fs.relglob src-dir src-expr))]
    (if (fs.macro-file-path? path)
      ;; Copy macro files without compiling
      (->> (.. src-dir path)
           (a.slurp)
           (a.spit (.. dest-dir path)))

      ;; Compile .fnl files to .lua
      (file
        (.. src-dir path)
        (string.gsub
          (.. dest-dir path)
          ".fnl$" ".lua")))))
