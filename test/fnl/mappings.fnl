;; We have access to https://github.com/norcalli/nvim.lua
;; Aniseed is really just combining cool things to be greater than the sum of it's parts.
(local nvim (require :aniseed.nvim))

;; Where <localleader> is bound to comma.
;; I'm using the colon syntax which translates to strings just to be fancy.
;; Imagine each :keyword as "keyword".

(fn map! [mode from to suffix]
  "Map some keys (prefixed by <localleader>) to a command."
  (nvim.ex.autocmd
    :FileType :fennel
    (.. mode :map) :<buffer>
    (.. :<localleader> from)
    (.. to (or suffix ""))))

(fn plug-map! [mode from to suffix]
  "Adds a map in terms of map! but wraps the target command in <Plug>(...)."
  (map! mode from (.. "<Plug>(" to ")") suffix))

(nvim.ex.augroup :aniseed)
(nvim.ex.autocmd_)

;; ,E<motion> - evaluate a motion.
(plug-map! :n :E :AniseedEval)

;; ,ee - evaluate the current form.
(plug-map! :n :ee :AniseedEval :af)

;; ,er - evaluate the outermost form.
(plug-map! :n :er :AniseedEval :aF)

;; ,ef - evaluate the current file from disk.
(plug-map! :n :ef :AniseedEvalCurrentFile)

;; ,eb - evaluate the buffer from Neovim.
(map! :n :eb ":%AniseedEvalRange<cr>")

;; ,ee - evaluate the current visual selection.
(plug-map! :v :ee :AniseedEvalSelection)

(nvim.ex.augroup :END)

;; Reload the current file, just in case we opened a Fennel file and the mappings didn't fire.
(nvim.ex.edit)
