(local core (require :aniseed.core))
(local fs (require :aniseed.fs))
(local nvim (require :aniseed.nvim))
(local fennel (require :aniseed.fennel))

(fn file [src dest]
  (let [content (core.slurp src)
        (ok val) (xpcall
                   (fn []
                     (fennel.compileString content {:filename src}))
                   fennel.traceback)]
    (if ok
      (do
        (fs.ensure-ancestor-dirs dest)
        (core.spit dest val))
      (io.stderr.write val))))

(fn glob [src-expr src-dir dest-dir]
  (let [src-dir-len (core.inc (string.len src-dir))
        src-paths (->> (nvim.fn.globpath src-dir src-expr true true)
                       (core.map (fn [path]
                                   (string.sub path src-dir-len))))]
    (each [_ path (ipairs src-paths)]
      (file (.. src-dir path)
            (string.gsub
              (.. dest-dir path)
              ".fnl$" ".lua")))))

{:glob glob
 :file file}
