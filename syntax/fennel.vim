" Vim syntax file
" Language: FENNEL
" Maintainer: Calvin Rose

" TODO: find most simple way to highlight :until and :into in a proper places
" TODO: highlight : in tables with FennelKeyword
" TODO: remove . and : from FennelSymbol and highlight them separatly
" then they are could be removed from iskeyword maybe? : not allowed in symbol
" at all, `.` is allowed at the start and end of the symbol
if exists("b:current_syntax")
  finish
endif

let s:cpo_sav = &cpo
set cpo&vim

syntax sync minlines=100

if get(g:, 'fennel_fold') > 0
  setlocal foldmethod=syntax
endif

" comments
sy match FennelComment ";.*$" contains=FennelCommentTodo,@Spell display
sy keyword FennelCommentTodo contained FIXME XXX TODO FIXME: XXX: TODO:

" strings
sy region FennelString matchgroup=FennelStringDelimiter start=+"+ end=+"+
            \ skip=+\\\\\|\\"+ contains=FennelStringEscape,FennelStringEscapeError,@Spell
sy match FennelStringEscape +\\[abfnrtvz'"\\]+ contained
sy match FennelStringEscape +\\x[[:xdigit:]]\{2}+ contained
sy match FennelStringEscape +\\\%([0-1]\d\d\|2[0-4]\d\|25[0-5]\|\d\d\|\d\)+ contained
sy match FennelStringEscapeError +\\[^abfnrtvz'"\\x0-9]+ contained
sy match FennelStringEscapeError +\\\%([3-9]\d\d\|2[6-9]\d\|25[6-9]\)+ contained

syn keyword FennelConstant nil

syn keyword FennelBoolean true
syn keyword FennelBoolean false

" Fennel special forms
syn keyword FennelSpecialForm #
syn keyword FennelSpecialForm %
syn keyword FennelSpecialForm *
syn keyword FennelSpecialForm +
syn keyword FennelSpecialForm -
syn keyword FennelSpecialForm ->
syn keyword FennelSpecialForm ->>
syn keyword FennelSpecialForm -?>
syn keyword FennelSpecialForm -?>>
syn keyword FennelSpecialForm .
syn keyword FennelSpecialForm ?.
syn keyword FennelSpecialForm ..
syn keyword FennelSpecialForm /
syn keyword FennelSpecialForm //
syn keyword FennelSpecialForm :
syn keyword FennelSpecialForm <
syn keyword FennelSpecialForm <=
syn keyword FennelSpecialForm =
syn keyword FennelSpecialForm >
syn keyword FennelSpecialForm >=
syn keyword FennelSpecialForm ^
syn keyword FennelSpecialForm and
syn keyword FennelSpecialForm comment
syn keyword FennelSpecialForm do
syn keyword FennelSpecialForm doc
syn keyword FennelSpecialForm doto
syn keyword FennelSpecialForm each
syn keyword FennelSpecialForm eval-compiler
syn keyword FennelSpecialForm fn
syn keyword FennelSpecialForm for
syn keyword FennelSpecialForm global
syn keyword FennelSpecialForm hashfn
syn keyword FennelSpecialForm if
syn keyword FennelSpecialForm import-macros
syn keyword FennelSpecialForm include
syn keyword FennelSpecialForm lambda
syn keyword FennelSpecialForm length
syn keyword FennelSpecialForm let
syn keyword FennelSpecialForm local
syn keyword FennelSpecialForm lua
syn keyword FennelSpecialForm macro
syn keyword FennelSpecialForm macrodebug
syn keyword FennelSpecialForm macros
syn keyword FennelSpecialForm match
syn keyword FennelSpecialForm not
syn keyword FennelSpecialForm not=
syn keyword FennelSpecialForm or
syn keyword FennelSpecialForm partial
syn keyword FennelSpecialForm pick-args
syn keyword FennelSpecialForm pick-values
syn keyword FennelSpecialForm quote
syn keyword FennelSpecialForm require-macros
syn keyword FennelSpecialForm set
syn keyword FennelSpecialForm set-forcibly!
syn keyword FennelSpecialForm tset
syn keyword FennelSpecialForm values
syn keyword FennelSpecialForm var
syn keyword FennelSpecialForm when
syn keyword FennelSpecialForm while
syn keyword FennelSpecialForm ~=
syn keyword FennelSpecialForm with-open
syn keyword FennelSpecialForm λ
syn keyword FennelSpecialForm collect
syn keyword FennelSpecialForm icollect
syn keyword FennelSpecialForm accumulate

" Aniseed macros
syn keyword FennelSpecialForm module
syn keyword FennelSpecialForm defn
syn keyword FennelSpecialForm defn-
syn keyword FennelSpecialForm def
syn keyword FennelSpecialForm def-
syn keyword FennelSpecialForm defonce
syn keyword FennelSpecialForm defonce-
syn keyword FennelSpecialForm deftest
syn keyword FennelSpecialForm time
syn keyword FennelSpecialForm *module*
syn keyword FennelSpecialForm *module-name*
syn keyword FennelSpecialForm *file*

" Lua keywords
syntax keyword LuaSpecialValue
	\ _G
	\ _VERSION
	\ assert
	\ collectgarbage
	\ dofile
	\ error
	\ getmetatable
	\ ipairs
	\ load
	\ loadfile
	\ next
	\ pairs
	\ pcall
	\ print
	\ rawequal
	\ rawget
	\ rawlen
	\ rawset
	\ require
	\ autoload
	\ select
	\ setmetatable
	\ tonumber
	\ tostring
	\ type
	\ xpcall
	\ coroutine
	\ coroutine.create
	\ coroutine.isyieldable
	\ coroutine.resume
	\ coroutine.running
	\ coroutine.status
	\ coroutine.wrap
	\ coroutine.yield
	\ debug
	\ debug.debug
	\ debug.gethook
	\ debug.getinfo
	\ debug.getlocal
	\ debug.getmetatable
	\ debug.getregistry
	\ debug.getupvalue
	\ debug.getuservalue
	\ debug.sethook
	\ debug.setlocal
	\ debug.setmetatable
	\ debug.setupvalue
	\ debug.setuservalue
	\ debug.traceback
	\ debug.upvalueid
	\ debug.upvaluejoin
	\ io
	\ io.close
	\ io.flush
	\ io.input
	\ io.lines
	\ io.open
	\ io.output
	\ io.popen
	\ io.read
	\ io.stderr
	\ io.stdin
	\ io.stdout
	\ io.tmpfile
	\ io.type
	\ io.write
	\ math
	\ math.abs
	\ math.acos
	\ math.asin
	\ math.atan
	\ math.ceil
	\ math.cos
	\ math.deg
	\ math.exp
	\ math.floor
	\ math.fmod
	\ math.huge
	\ math.log
	\ math.max
	\ math.maxinteger
	\ math.min
	\ math.mininteger
	\ math.modf
	\ math.pi
	\ math.rad
	\ math.random
	\ math.randomseed
	\ math.sin
	\ math.sqrt
	\ math.tan
	\ math.tointeger
	\ math.type
	\ math.ult
	\ os
	\ os.clock
	\ os.date
	\ os.difftime
	\ os.execute
	\ os.exit
	\ os.getenv
	\ os.remove
	\ os.rename
	\ os.setlocale
	\ os.time
	\ os.tmpname
	\ package
	\ package.config
	\ package.cpath
	\ package.loaded
	\ package.loadlib
	\ package.path
	\ package.preload
	\ package.searchers
	\ package.searchpath
	\ string
	\ string.byte
	\ string.char
	\ string.dump
	\ string.find
	\ string.format
	\ string.gmatch
	\ string.gsub
	\ string.len
	\ string.lower
	\ string.match
	\ string.pack
	\ string.packsize
	\ string.rep
	\ string.reverse
	\ string.sub
	\ string.unpack
	\ string.upper
	\ table
	\ table.concat
	\ table.insert
	\ table.move
	\ table.pack
	\ table.remove
	\ table.sort
	\ table.unpack
	\ utf8
	\ utf8.char
	\ utf8.charpattern
	\ utf8.codepoint
	\ utf8.codes
	\ utf8.len
	\ utf8.offset

" Fennel Symbols
let s:symcharnodig = '\!\$%\&\#\*\+\-./:<=>?A-Z^_a-z|\x80-\U10FFFF'
let s:symchar = '0-9' . s:symcharnodig
execute 'syn match FennelSymbol "\v<%([' . s:symcharnodig . '])%([' . s:symchar . '])*>"'
execute 'syn match FennelKeyword "\v<:%([' . s:symchar . '])*>"'
unlet! s:symchar s:symcharnodig

syn match FennelQuote "`"
syn match FennelQuote "@"


" Grammar root
syntax cluster FennelTop contains=@Spell,FennelComment,FennelConstant,FennelQuote,FennelKeyword,LuaSpecialValue,FennelSymbol,FennelNumber,FennelString,FennelList,FennelArray,FennelTable,FennelSpecialForm,FennelBoolean

syntax region FennelList matchgroup=FennelParen start="("  end=")" contains=@FennelTop fold
syntax region FennelArray matchgroup=FennelParen start="\[" end="]" contains=@FennelTop fold
syntax region FennelTable matchgroup=FennelParen start="{"  end="}" contains=@FennelTop fold

" Highlight superfluous closing parens, brackets and braces.
" symbols
let s:allowed_chars = '-!\$%#*+./:<=>?^_|'
let s:unicode_range = '\x80-\U10FFFF'
let s:symchar = s:allowed_chars .. 'A-Za-z' .. s:unicode_range
if get(g:, "fennel_highlight_symbol", 1)
  exe printf('sy match FennelSymbol "\<[%s][%s0-9]*\>"', s:symchar, s:symchar)
endif
exe printf('sy match FennelKeyword "\<:[%s0-9]*\>"', s:symchar)
unlet! s:allowed_chars s:unicode_range s:symchar

" hexadecimal constant
sy match FennelNumber "\c\<[-+]\?0x[0-9a-f]\+\%(\.[0-9a-f]*\)\?\%(p[-+]\?\d\+\)\?\>"
sy match FennelNumber "\c\<[-+]\?0x[0-9a-f]*\%(\.[0-9a-f]\+\)\?\%(p[-+]\?\d\+\)\?\>"
" decimal and floating point constants
sy match FennelNumber "\<[-+]\?\d\+\%(\.\d*\)\?\%([eE][-+]\?\d\+\)\?\>"
sy match FennelNumber "\<[-+]\?\d*\%(\.\d\+\)\?\%([eE][-+]\?\d\+\)\?\>"

syntax match FennelError "]\|}\|)"

syntax sync fromstart

" Highlighting
hi def link FennelComment Comment
hi def link FennelSymbol Identifier
hi def link FennelNumber Number
hi def link FennelConstant Constant
hi def link FennelKeyword Keyword
hi def link FennelSpecialForm Special
hi def link LuaSpecialValue Special
hi def link FennelString String
hi def link FennelBuffer String
hi def link FennelStringDelimiter String
hi def link FennelBoolean Boolean
hi def link FennelStringEscape Special
hi def link FennelStringEscapeError Error

hi def link FennelQuote SpecialChar
hi def link FennelParen Delimiter

let b:current_syntax = "fennel"

let &cpo = s:cpo_sav
unlet! s:cpo_sav

" vim: sw=2 et
