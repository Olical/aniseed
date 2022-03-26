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

" If not specified get lua version shipped with neovim
let s:lua_version = str2float(split(luaeval("_VERSION"))[1])
let g:fennel_lua_version = get(g:, 'fennel_lua_version', s:lua_version)
unlet! s:lua_version

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

" keywords
sy keyword FennelConstant nil
sy keyword FennelBoolean true false
sy keyword FennelLogicalOperator and not or
sy keyword FennelOperator >  <  >=  <=  =  not  not=  ~=
sy keyword FennelOperator +  -  *  /  %  ^
sy keyword FennelOperator .  ..  :
sy keyword FennelDestructure & &as

sy keyword FennelFunctionDefine fn hashfn lambda λ
sy keyword FennelInclude import-macros include require-macros
sy keyword FennelRepeat each for while
sy keyword FennelConditional if match when
sy keyword FennelDefine global local let var macros
sy keyword FennelSpecialForm set set-forcibly! tset where #
sy keyword FennelSpecialForm comment do eval-compiler length lua quote values
sy keyword FennelMacro ->  ->>  -?>  -?>>  ?.
sy keyword FennelMacro accumulate collect doto icollect macro macrodebug pick-args pick-values with-open partial
sy match FennelQuote '`'
sy match FennelUnquote ','

" Lua functions
sy keyword FennelLuaGlobal _G _VERSION _ENV coroutine debug io math os package string table
sy keyword FennelLuaGlobal package.config package.cpath package.loaded package.path package.preload package.searchpath
sy keyword FennelLuaFunction assert collectgarbage dofile error getmetatable ipairs load
sy keyword FennelLuaFunction loadfile next pairs pcall print rawequal rawget rawset require
sy keyword FennelLuaFunction select setmetatable tonumber tostring type xpcall
sy keyword FennelLuaFunction coroutine.create coroutine.isyieldable coroutine.resume
sy keyword FennelLuaFunction coroutine.running coroutine.status coroutine.wrap coroutine.yield
sy keyword FennelLuaFunction debug.debug debug.gethook debug.getinfo debug.getlocal debug.getmetatable
sy keyword FennelLuaFunction debug.getregistry debug.getupvalue debug.sethook debug.setlocal debug.setmetatable
sy keyword FennelLuaFunction debug.setupvalue debug.traceback debug.upvalueid debug.upvaluejoin
sy keyword FennelLuaFunction io.close io.flush io.input io.lines io.open io.output io.popen io.read
sy keyword FennelLuaFunction io.stderr io.stdin io.stdout io.tmpfile io.type io.write
sy keyword FennelLuaFunction math.abs math.acos math.asin math.atan math.ceil math.cos math.deg math.exp
sy keyword FennelLuaFunction math.floor math.fmod math.huge math.log math.max math.min math.modf math.pi
sy keyword FennelLuaFunction math.rad math.random math.randomseed math.sin math.sqrt math.tan
sy keyword FennelLuaFunction os.clock os.date os.difftime os.execute os.exit os.getenv os.remove
sy keyword FennelLuaFunction os.rename os.setlocale os.time os.tmpname package.loadlib
sy keyword FennelLuaFunction string.byte string.char string.dump string.find string.format
sy keyword FennelLuaFunction string.gmatch string.gsub string.len string.lower string.match
sy keyword FennelLuaFunction string.rep string.reverse string.sub string.upper
sy keyword FennelLuaFunction table.concat table.insert table.move table.remove table.sort

if g:fennel_lua_version < 5.19 " 5.1 only
  sy keyword FennelLuaGlobal package.loaders
  sy keyword FennelLuaFunction getfenv loadstring module setfenv unpack debug.getfenv debug.setfenv
  sy keyword FennelLuaFunction math.log10 package.seeall table.maxn
endif

if g:fennel_lua_version < 5.29 " 5.1 5.2
  sy keyword FennelLuaFunction math.atan2 math.cosh math.frexp math.ldexp math.pow math.sinh
endif

if g:fennel_lua_version > 5.19 && g:fennel_lua_version < 5.29 " 5.2 only
  sy keyword FennelLuaGlobal bit32
  sy keyword FennelLuaFunction bit32.arshift bit32.band bit32.bnot bit32.bor bit32.btest bit32.bxor
  sy keyword FennelLuaFunction bit32.extract bit32.lrotate bit32.lshift bit32.replace bit32.rrotate bit32.rshift
endif

if g:fennel_lua_version > 5.19 " 5.2+
  sy keyword FennelLuaGlobal package.searchers
  sy keyword FennelLuaFunction debug.getuservalue debug.setuservalue table.pack table.unpack
endif

if g:fennel_lua_version > 5.29 " 5.3+
  sy keyword FennelOperator //
  sy keyword FennelLuaGlobal utf8
  sy keyword FennelLuaFunction rawlen math.maxinteger math.mininteger math.tointeger math.type math.ult
  sy keyword FennelLuaFunction string.pack string.packsize string.unpack
  sy keyword FennelLuaFunction utf8.char utf8.charpattern utf8.codepoint utf8.codes utf8.len utf8.offset
endif
" if lua version is 5.3+ or explicitly required because they
" could be activated for luajit with fennel compiler flag --use-bit-lib
" or `useBitLib` in the options table
if g:fennel_lua_version > 5.29 || get(g:, "fennel_bitwise")
  sy keyword FennelBitwise lshift rshift band bor bxor bnot
endif

if g:fennel_lua_version > 5.39 " 5.4
  sy keyword FennelLuaFunction warn coroutine.close
endif

if get(g:, "fennel_highlight_luajit", 1)
  sy keyword FennelLuajitFunction gcinfo newproxy table.foreach table.foreachi table.getn
  sy keyword FennelLuajitFunction bit.arshift bit.band bit.bnot bit.bor bit.bswap bit.bxor
  sy keyword FennelLuajitFunction bit.lshift bit.rol bit.ror bit.rshift bit.tobit bit.tohex
  sy keyword FennelLuajitFunction jit.attach jit.flush jit.off jit.on jit.security jit.status

  hi def link FennelLuajitFunction FennelLuaFunction
endif

" Aniseed
if get(g:, "fennel_highlight_aniseed", 1)
  sy keyword FennelAniseedFunctionDefine defn[-] deftest
  sy keyword FennelAniseedDefine def[-] defonce[-]
  sy keyword FennelAniseedInclude module autoload
  sy keyword FennelAniseedMacro time
  sy keyword FennelAniseedVar *module* *module-name* *file*

  hi def link FennelAniseedInclude FennelInclude
  hi def link FennelAniseedDefine FennelDefine
  hi def link FennelAniseedFunctionDefine FennelFunctionDefine
  hi def link FennelAniseedMacro FennelMacro
  hi def link FennelAniseedVar Special
endif

" symbols
let s:allowed_chars = '-!\$%#*+./:<=>?^_|'
let s:unicode_range = '\x80-\U10FFFF'
let s:symchar = s:allowed_chars .. 'A-Za-z' .. s:unicode_range
if get(g:, "fennel_highlight_symbol", 1)
  exe printf('sy match FennelSymbol "\<[%s][%s0-9]*\>"', s:symchar, s:symchar)
endif
exe printf('sy match FennelKeyword "\<:[%s0-9]*\>"', s:symchar)
unlet! s:allowed_chars s:unicode_range s:symchar

" numbers
let s:sign = '\%([-+]_*\)\?'
let s:req_digit = '\%(\d_*\)\+'
let s:unreq_digit = '\%(\d_*\)*'
let s:req_fractional = '\%(\._*' .. s:req_digit .. '\)'
let s:unreq_fractional = '\%(\._*' .. s:unreq_digit .. '\)\?'
let s:number = '\%(' .. s:req_digit .. s:unreq_fractional .. '\|'
      \ .. s:unreq_digit .. s:req_fractional .. '\)'
let s:dec_exp = '\%([eE]_*' .. s:sign .. s:req_digit .. '\)\?'
let s:decimal = '\<' .. s:sign .. s:number .. s:dec_exp .. '\>'
let s:req_hex = '\%([[:xdigit:]]_*\)\+'
let s:unreq_hex = '\%([[:xdigit:]]_*\)*'
let s:req_hex_frac = '\%(\._*' .. s:req_hex .. '\)'
let s:unreq_hex_frac = '\%(\._*' .. s:unreq_hex .. '\)\?'
let s:hexnumber = '\%(' .. s:req_hex .. s:unreq_hex_frac .. '\|'
      \ .. s:unreq_hex .. s:req_hex_frac .. '\)'
let s:bin_exp = '\%([pP]_*' .. s:sign .. s:req_digit .. '\)\?'
let s:hexadecimal = '\<' .. s:sign .. '0_*[xX]_*' .. s:hexnumber .. s:bin_exp .. '\>'
exe 'sy match FennelNumber "' .. s:decimal .. '"'
exe 'sy match FennelNumber "' .. s:hexadecimal .. '"'
unlet! s:sign s:req_digit s:unreq_digit s:req_fractional s:unreq_fractional s:number s:dec_exp s:decimal
unlet! s:req_hex s:unreq_hex s:req_hex_frac s:unreq_hex_frac s:hexnumber s:bin_exp s:hexadecimal

" lists and tables
sy cluster FennelForm contains=FennelComment,FennelString,FennelDefine,FennelOperator,FennelNumber,
      \FennelFunctionDefine,FennelInclude,FennelRepeat,FennelConditional,FennelKeyword,FennelMacro,
      \FennelQuote,FennelUnquote,FennelBitwise,FennelSymbol,FennelList,FennelSeqTable,FennelTable,
      \FennelLogicalOperator,FennelSpecialForm,FennelConstant,FennelBoolean,FennelDestructure
sy cluster FennelAniseed contains=FennelAniseedFunctionDefine,FennelAniseedDefine,
      \FennelAniseedInclude,FennelAniseedMacro,FennelAniseedVar
sy cluster FennelLua contains=FennelLuaGlobal,FennelLuaFunction,FennelLuajitFunction
sy cluster FennelTop contains=@FennelForm,@FennelAniseed,@FennelLua
sy region FennelList matchgroup=FennelParen start="(" end=")" contains=@FennelTop fold
sy region FennelSeqTable matchgroup=FennelParen start="\[" end="]" contains=@FennelTop fold
sy region FennelTable matchgroup=FennelParen start="{"  end="}" contains=@FennelTop fold

" Superfluous closing parens, brackets and braces.
syntax match FennelError "]\|}\|)"

" Highlighting
hi def link FennelComment Comment
hi def link FennelSymbol Identifier
hi def link FennelNumber Number
hi def link FennelConstant Constant
hi def link FennelKeyword Keyword
hi def link FennelString String
hi def link FennelStringDelimiter String
hi def link FennelBoolean Boolean
hi def link FennelStringEscape Special
hi def link FennelStringEscapeError Error
hi def link FennelError Error
hi def link FennelQuote SpecialChar
hi def link FennelUnquote FennelQuote
hi def link FennelParen Delimiter
hi def link FennelInclude Include
hi def link FennelRepeat Repeat
hi def link FennelConditional Conditional
hi def link FennelDefine Define
hi def link FennelSpecialForm FennelDefine
hi def link FennelMacro Macro
hi def link FennelOperator Operator
hi def link FennelLogicalOperator FennelOperator
hi def link FennelBitwise FennelOperator
hi def link FennelFunctionDefine Keyword
hi def link FennelLuaGlobal Special
hi def link FennelLuaFunction Special
hi def link FennelDestructure Label

let b:current_syntax = "fennel"

let &cpo = s:cpo_sav
unlet! s:cpo_sav

" vim: sw=2 et
