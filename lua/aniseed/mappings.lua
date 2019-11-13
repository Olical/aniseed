local nvim = require("aniseed.nvim")
return nvim.set_keymap("n", "<Plug>(AniseedEval)", ":<c-u>echom 'Hello, Aniseed!'<CR>", {noremap = true})
