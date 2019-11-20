(local core (require :aniseed.core))
(local str (require :aniseed.string))
(local nvim (require :aniseed.nvim))
(local nu (require :aniseed.nvim.util))
(local view (require :aniseed.view))
(local fennel (require :aniseed.fennel))

;; TODO Replace the existing module if any result contains module name?

(fn show [x]
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
  (show (fennel.eval code)))

(fn eval-selection [...]
  (eval (selection ...)))

(fn eval-range [first-line last-line]
  (eval (str.join "\n" (nvim.fn.getline first-line last-line))))

(fn eval-file [path]
  (show (fennel.dofile path)))

(fn init []
  (nu.fn-bridge
    :AniseedSelection
    :aniseed.mappings :selection)

  (nu.fn-bridge
    :AniseedEval
    :aniseed.mappings :eval)

  (nu.fn-bridge
    :AniseedEvalFile
    :aniseed.mappings :eval-file)

  (nu.fn-bridge
    :AniseedEvalRange
    :aniseed.mappings :eval-range
    {:range true})

  (nu.fn-bridge
    :AniseedEvalSelection
    :aniseed.mappings :eval-selection)

  (nvim.ex.command_ :-nargs=1 :AniseedEval "call AniseedEval(<q-args>)")
  (nvim.ex.command_ :-range :AniseedEvalRange "<line1>,<line2>call AniseedEvalRange()")

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

{:eval eval
 :selection selection
 :eval-selection eval-selection
 :eval-range eval-range
 :eval-file eval-file
 :init init}
