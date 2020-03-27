(module aniseed.mapping
  {require {a aniseed.core
            str aniseed.string
            nvim aniseed.nvim
            nu aniseed.nvim.util
            fennel aniseed.fennel
            eval aniseed.eval
            test aniseed.test}})

(defn handle-result [ok? result]
  (if (not ok?)
    (nvim.err_writeln result)

    (let [mod (and (a.table? result) (. result :aniseed/module))]
      (when mod
        (when (= nil (. package.loaded mod))
          (tset package.loaded mod {}))

        (each [k v (pairs result)]
          (tset (. package.loaded mod) k v)))

      (vim.schedule
        (fn []
          (a.pr result))))))

(defn selection [type ...]
  (let [sel-backup nvim.o.selection
        [visual?] [...]]

    (nvim.ex.let "g:aniseed_reg_backup = @@")
    (set nvim.o.selection :inclusive)

    (if
      visual? (nu.normal (.. "`<" type "`>y"))
      (= type :line) (nu.normal "'[V']y")
      (= type :block) (nu.normal "`[`]y")
      (nu.normal "`[v`]y"))

    (let [selection (nvim.eval "@@")]
      (set nvim.o.selection sel-backup)
      (nvim.ex.let "@@ = g:aniseed_reg_backup")
      selection)))

(def- buffer-header-length 20)
(def- default-module-name "aniseed.user")
(def- buffer-module-pattern "[(]%s*module%s*(.-)[%s){]")
(defn- buffer-module-name []
  (let [header (->> (nvim.buf_get_lines 0 0 buffer-header-length false)
                    (str.join "\n"))]
    (or (string.match header buffer-module-pattern)
        default-module-name)))

(defn eval-str [code opts]
  (-> (.. "(module " (buffer-module-name) ")" code)
      (eval.str opts)
      (handle-result)))

(defn eval-selection [...]
  (eval-str (selection ...)))

(defn eval-range [first-line last-line]
  (eval-str (str.join "\n" (nvim.fn.getline first-line last-line))))

(defn eval-file [filename]
  (-> (a.slurp filename)
      (eval.str {:filename filename})
      (handle-result)))

(defn run-tests [name]
  (test.run name))

(defn run-all-tests []
  (test.run-all))

(defn init-commands []
  (nu.fn-bridge
    :AniseedSelection
    :aniseed.mapping :selection)

  (nu.fn-bridge
    :AniseedEval
    :aniseed.mapping :eval-str)

  (nu.fn-bridge
    :AniseedEvalFile
    :aniseed.mapping :eval-file)

  (nu.fn-bridge
    :AniseedEvalRange
    :aniseed.mapping :eval-range
    {:range true})

  (nu.fn-bridge
    :AniseedEvalSelection
    :aniseed.mapping :eval-selection)

  (nu.fn-bridge
    :AniseedRunTests
    :aniseed.mapping :run-tests)

  (nu.fn-bridge
    :AniseedRunAllTests
    :aniseed.mapping :run-all-tests)

  (nvim.ex.command_ :-nargs=1 :AniseedEval "call AniseedEval(<q-args>)")
  (nvim.ex.command_ :-nargs=1 :AniseedEvalFile "call AniseedEvalFile(<q-args>)")
  (nvim.ex.command_ :-range :AniseedEvalRange "<line1>,<line2>call AniseedEvalRange()")
  (nvim.ex.command_ :-nargs=1 :AniseedRunTests "call AniseedRunTests(<q-args>)")
  (nvim.ex.command_ :-nargs=0 :AniseedRunAllTests "call AniseedRunAllTests()")

  (nvim.set_keymap
    :n (nu.plug :AniseedEval)
    ":set opfunc=AniseedEvalSelection<cr>g@"
    {:noremap true
     :silent true})

  (nvim.set_keymap
    :n (nu.plug :AniseedEvalCurrentFile)
    ":call AniseedEvalFile(expand('%'))<cr>"
    {:noremap true
     :silent true})

  (nvim.set_keymap
    :v (nu.plug :AniseedEvalSelection)
    ":<c-u>call AniseedEvalSelection(visualmode(), v:true)<cr>"
    {:noremap true
     :silent true}))

(defn init-mappings []
  (nvim.ex.augroup :aniseed)
  (nvim.ex.autocmd_)
  (nu.ft-map :fennel :n :E (nu.plug :AniseedEval))
  (nu.ft-map :fennel :n :ee (.. (nu.plug :AniseedEval) :af))
  (nu.ft-map :fennel :n :er (.. (nu.plug :AniseedEval) :aF))
  (nu.ft-map :fennel :n :ef (nu.plug :AniseedEvalCurrentFile))
  (nu.ft-map :fennel :v :ee (nu.plug :AniseedEvalSelection))
  (nu.ft-map :fennel :n :eb ":%AniseedEvalRange<cr>")
  (nu.ft-map :fennel :n :t ":AniseedRunAllTests<cr>")
  (nvim.ex.augroup :END))

(defn init []
  (init-commands)
  (init-mappings))
