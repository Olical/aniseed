(local nvim (require :aniseed.nvim))

(nvim.set_keymap "n" "<Plug>(AniseedEval)" ":echom 'Hello, Aniseed!'<CR>" {:noremap true})
