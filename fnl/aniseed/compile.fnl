(local core (require :aniseed.core))
(local fs (require :aniseed.fs))
(local nvim (require :aniseed.nvim))
(local fennel (require :aniseed.fennel))

(fn str [content opts]
  "Compile some Fennel code as a string into Lua. Maps to fennel.compileString
  with some wrapping, returns an (ok? result) tuple."
  (xpcall
    (fn []
      (fennel.compileString content opts))
    fennel.traceback))

(fn file [src dest opts]
  "Compile the source file into the destination file if the source file was
  modified more recently. Will create any required ancestor directories for the
  destination file to exist."
  (when (or (and opts opts.force)
            (> (nvim.fn.getftime src) (nvim.fn.getftime dest)))
    (let [content (core.slurp src)]
      (match (str content {:filename src})
        (false err) (io.stderr.write err)
        (true result) (do
                        (fs.ensure-ancestor-dirs dest)
                        (core.spit dest result))))))

(fn glob [src-expr src-dir dest-dir opts]
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

{:aniseed/module :aniseed.compile
 :glob glob
 :file file
 :str str}
