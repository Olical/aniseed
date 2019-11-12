(local core (require :aniseed.core))
(local nvim (require :aniseed.nvim))
(local fennel (require :aniseed.fennel))

(fn ensure-parent-dirs [path]
  (let [parent (nvim.fn.fnamemodify path ":h")]
    (nvim.fn.mkdir parent "p")))

(fn glob [src-dir src-expr dest-dir]
  (let [src-dir-len (core.inc (string.len src-dir))
        src-paths (->> (nvim.fn.globpath src-dir src-expr true true)
                       (core.map (fn [path]
                                   (string.sub path src-dir-len))))]
    (each [_ path (ipairs src-paths)]
      (let [src (.. src-dir path)
            dest (string.gsub
                   (.. dest-dir path)
                   ".fnl$" ".lua")
            content (core.slurp src)
            (ok val) (xpcall
                       (fn []
                         (fennel.compileString content {:filename src}))
                       fennel.traceback)]
        (if ok
          (do
            (ensure-parent-dirs dest)
            (core.spit dest val))
          (io.stderr.write val))))))

{:glob glob}
