" Vim filetype plugin file
" Language: FENNEL
" Maintainer: Calvin Rose

if exists("b:did_ftplugin")
	finish
endif
let b:did_ftplugin = 1

let s:cpo_save = &cpo
set cpo&vim

"setlocal iskeyword+=!,_,%,?,-,*,!,+,/,=,<,>,.,:,$,^
setlocal iskeyword=!,$,%,#,*,+,-,.,/,:,<,=,>,?,_,a-z,A-Z,48-57,128-247,124,94

" There will be false positives, but this is better than missing the whole set
" of user-defined def* definitions.
setlocal define=\\v[(/]def(ault)@!\\S*

setlocal suffixesadd=.fnl

" Remove 't' from 'formatoptions' to avoid auto-wrapping code.
setlocal formatoptions-=t

setlocal comments=n:;
setlocal commentstring=;\ %s

setlocal lispwords+=collect,icollect,with-open,module,accumulate,when-let,if-let

let &cpo = s:cpo_save
