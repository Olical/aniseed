(local nvim (require :aniseed.nvim))
(local view (require :aniseed.view))
(local fennel (require :aniseed.fennel))

(fn normal [...]
  "Execute some command as if you were in normal mode silently."
  (nvim.ex.silent (.. "exe \"normal! " ... "\"")))

(fn def-viml-bridge-function [viml-name lua-name]
  "Creates a VimL function that calls through to a Lua function in this file."
  (nvim.ex.function_
    (.. viml-name
        "(...)
              return luaeval(\"require('aniseed/mappings')['" lua-name "'](unpack(_A))\", a:000)
              endfunction")))

;; Selection based upon the following VimL.
; let sel_save = &selection
; let &selection = "inclusive"
; let reg_save = @@

; if a:0  " Invoked from Visual mode, use '< and '> marks.
;   silent exe "normal! `<" . a:type . "`>y"
; elseif a:type == 'line'
;   silent exe "normal! '[V']y"
; elseif a:type == 'block'
;   silent exe "normal! `[\<C-V>`]y"
; else
;   silent exe "normal! `[v`]y"
; endif

; echomsg strlen(substitute(@@, '[^ ]', '', 'g'))

; let &selection = sel_save
; let @@ = reg_save

(fn selection [type ...]
  (let [sel-backup nvim.o.selection
        [visual?] [...]]

    (nvim.ex.let "g:aniseed_reg_backup = @@")
    (set nvim.o.selection :inclusive)

    (if
      visual? (normal "`<" type "`>y")
      (= type :line) (normal "'[V']y")

      ;; TODO Block doesn't work?
      (= type :block) (normal "`[`]y")

      (normal "`[v`]y"))

    (let [selection (nvim.eval "@@")]
      (set nvim.o.selection sel-backup)
      (nvim.ex.let "@@ = g:aniseed_reg_backup")
      selection)))

;; TODO Why do multi-line outputs only show the last line?
(fn eval [code]
  (let [result (fennel.eval code)]
    (vim.schedule
      (fn []
        (print (view result))))
    result))

(fn eval-selection [...]
  (eval (selection ...)))

(fn init []
  (def-viml-bridge-function :AniseedSelection :selection)
  (def-viml-bridge-function :AniseedEval :eval)
  (def-viml-bridge-function :AniseedEvalSelection :eval-selection)

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
