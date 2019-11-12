(local core (require :aniseed.core))
(local fs (require :aniseed.fs))
(local nvim (require :aniseed.nvim))
(local fennel (require :aniseed.fennel))

(fn code-string [content opts]
  (xpcall
    (fn []
      (fennel.compileString content opts))
    fennel.traceback))

(fn file [src dest]
  (when (> (nvim.fn.getftime src) (nvim.fn.getftime dest))
    (let [content (core.slurp src)]
      (match (code-string content {:filename src})
        (false err) (io.stderr.write err)
        (true result) (do
                        (fs.ensure-ancestor-dirs dest)
                        (core.spit dest result))))))

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
 :file file
 :code-string code-string}
