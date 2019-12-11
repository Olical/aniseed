(local core (require :aniseed.core))
(local str (require :aniseed.string))
(local nvim (require :aniseed.nvim))
(local nu (require :aniseed.nvim.util))
(local fennel (require :aniseed.fennel))
(local test (require :aniseed.test))

(fn handle-result [x]
  (let [module (and (core.table? x) (. x :aniseed/module))]
    (when module
      (when (= nil (. package.loaded module))
        (tset package.loaded module {}))

      (each [k v (pairs x)]
        (tset (. package.loaded module) k v))))

  (vim.schedule
    (fn []
      (core.pr x))))

(fn selection [type ...]
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

(fn eval [code]
  (handle-result (fennel.eval code)))

(fn eval-selection [...]
  (eval (selection ...)))

(fn eval-range [first-line last-line]
  (eval (str.join "\n" (nvim.fn.getline first-line last-line))))

(fn eval-file [path]
  (handle-result (fennel.dofile path)))

(fn run-tests [name]
  (test.run name))

(fn run-all-tests []
  (test.run-all))

(fn init []
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

{:aniseed/module :aniseed.mapping
 :eval eval
 :selection selection
 :eval-selection eval-selection
 :eval-range eval-range
 :eval-file eval-file
 :run-tests run-tests
 :run-all-tests run-all-tests
 :init init}
