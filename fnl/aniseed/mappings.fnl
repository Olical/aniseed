(local nvim (require :aniseed.nvim))
(local nu (require :aniseed.nvim.util))
(local view (require :aniseed.view))
(local fennel (require :aniseed.fennel))

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
  (let [result (fennel.eval code)]
    (vim.schedule
      (fn []
        (print (view result {:one-line true}))))))

(fn eval-selection [...]
  (eval (selection ...)))

(fn init []
  (nu.fn-bridge
    :AniseedSelection
    :aniseed.mappings :selection)

  (nu.fn-bridge
    :AniseedEval
    :aniseed.mappings :eval)

  (nu.fn-bridge
    :AniseedEvalSelection
    :aniseed.mappings :eval-selection)

  (nvim.ex.command_ :-nargs=1 :AniseedEval "call AniseedEval(<q-args>)")

  (nvim.set_keymap
    :n "<Plug>(AniseedEval)"
    ":set opfunc=AniseedEvalSelection<cr>g@"
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
 :init init}
