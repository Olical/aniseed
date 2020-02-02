(module aniseed.mapping
  {require {core aniseed.core
            str aniseed.string
            nvim aniseed.nvim
            nu aniseed.nvim.util
            fennel aniseed.fennel
            test aniseed.test}})

(defn handle-result [x]
  (let [mod (and (core.table? x) (. x :aniseed/module))]
    (when mod
      (when (= nil (. package.loaded mod))
        (tset package.loaded mod {}))

      (each [k v (pairs x)]
        (tset (. package.loaded mod) k v))))

  (vim.schedule
    (fn []
      (core.pr x))))

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

(defn eval [code]
  (handle-result (fennel.eval code)))

(defn eval-selection [...]
  (eval (selection ...)))

(defn eval-range [first-line last-line]
  (eval (str.join "\n" (nvim.fn.getline first-line last-line))))

(defn eval-file [path]
  (handle-result (fennel.dofile path)))

(defn run-tests [name]
  (test.run name))

(defn run-all-tests []
  (test.run-all))

(defn init []
  (nu.fn-bridge
    :AniseedSelection
    :aniseed.mapping :selection)

  (nu.fn-bridge
    :AniseedEval
    :aniseed.mapping :eval)

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
    :n "<Plug>(AniseedEval)"
    ":set opfunc=AniseedEvalSelection<cr>g@"
    {:noremap true
     :silent true})

  (nvim.set_keymap
    :n "<Plug>(AniseedEvalCurrentFile)"
    ":call AniseedEvalFile(expand('%'))<cr>"
    {:noremap true
     :silent true})

  (nvim.set_keymap
    :v "<Plug>(AniseedEvalSelection)"
    ":<c-u>call AniseedEvalSelection(visualmode(), v:true)<cr>"
    {:noremap true
     :silent true}))
