(local core (require :aniseed.core))
(local nvim (require :aniseed.nvim))
(local fs (require :aniseed.fs))
(local fennel (require :aniseed.fennel))

(fn glob [src-dir src-expr dest-dir]
  (let [src-dir-len (core.inc (string.len src-dir))
        src-paths (->> (nvim.call-function :globpath src-dir src-expr true true)
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
            (fs.ensure-parent-dirs dest)
            (core.spit dest val))
          (io.stderr.write val))))))

{:glob glob}
