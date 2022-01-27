(module aniseed.compile
  {autoload {a aniseed.core
             fs aniseed.fs
             nvim aniseed.nvim
             fennel aniseed.fennel}})

(defn macros-prefix [code opts]
  (let [macros-module :aniseed.macros
        filename (-?> (a.get opts :filename)
                      (string.gsub
                        (.. (nvim.fn.getcwd) fs.path-sep)
                        ""))]
    (.. "(local *file* "
        (if filename
          (.. "\"" (string.gsub filename "\\" "\\\\") "\"")
          "nil")
        ")"
        "(require-macros \"" macros-module "\")\n"
        "(wrap-module-body " (or code "") ")")))

;; Magic strings from the macros that allow us to emit clean code.
(def marker-prefix "ANISEED_")
(def delete-marker (.. marker-prefix "DELETE_ME"))
(def- delete-marker-pat (.. "\n[^\n]-\"" delete-marker "\".-"))

(defn str [code opts]
  "Compile some Fennel code as a string into Lua. Maps to
  fennel.compileString with some wrapping, returns an (ok? result)
  tuple. Automatically requires the Aniseed macros."

  (global ANISEED_STATIC_MODULES (= true (a.get opts :static?)))

  (let [fnl (fennel.impl)]
    (xpcall
      (fn []
        (-> (macros-prefix code opts)
            (fnl.compileString
              (a.merge! {:allowedGlobals false
                         :compilerEnv _G} opts))
            (string.gsub (.. delete-marker-pat "\n") "\n")
            (string.gsub (.. delete-marker-pat "$") "")))
      fnl.traceback)))

(defn file [src dest opts]
  "Compile the source file into the destination file. Will create any
  required ancestor directories for the destination file to exist."
  (let [code (a.slurp src)]
    (match (str code
                (a.merge!
                  {:filename src
                   :static? true}
                  opts))
      (false err) (nvim.err_writeln err)
      (true result) (do
                      (-> dest fs.basename fs.mkdirp)
                      (a.spit dest result)))))

(defn glob [src-expr src-dir dest-dir opts]
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
          ".fnl$" ".lua")
        opts))))
