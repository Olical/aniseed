fun! s:DetectFennel()
    if getline(1) =~# '^#!.*/bin/env\s\+fennel\>'
        setfiletype fennel
    endif
endfun

autocmd BufRead,BufNewFile *.fnl setfiletype fennel
autocmd BufNewFile,BufRead * call s:DetectFennel()
