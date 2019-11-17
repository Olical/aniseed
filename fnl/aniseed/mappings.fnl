(local nvim (require :aniseed.nvim))
(local view (require :aniseed.view))
(local fennel (require :aniseed.fennel))

;; TODO Define a command that takes a range or code.

(fn eval [type ...]
  (let [sel-backup nvim.o.selection
        [visual?] [...]
        normal (fn [...]
                 (nvim.ex.silent (.. "exe \"normal! " ... "\"")))]

    (nvim.ex.let "g:aniseed_reg_backup = @@")
    (set nvim.o.selection :inclusive)

    (if
      visual? (normal "`<" type "`>y")
      (= type :line) (normal "'[V']y")

      ;; TODO Block doesn't work?
      (= type :block) (normal "`[`]y")
      (normal "`[v`]y"))

    (let [result (fennel.eval (nvim.eval "@@"))]
      (set nvim.o.selection sel-backup)
      (nvim.ex.let "@@ = g:aniseed_reg_backup")

      (vim.schedule
        (fn []
          (print (view result))))

      result)))

(fn init []
  (nvim.ex.function_
    "AniseedEval(...)
    return luaeval(\"require('aniseed/mappings').eval(unpack(_A))\", a:000)
    endfunction")

  (nvim.set_keymap
    :n "<Plug>(AniseedEval)"
    ":set opfunc=AniseedEval<cr>g@"
    {:noremap true
     :silent true})

  (nvim.set_keymap
    :v "<Plug>(AniseedEvalSelection)"
    ":<c-u>call AniseedEval(visualmode(), v:true)<cr>"
    {:noremap true
     :silent true}))

{:eval eval
 :init init}
