set lispwords+=module

if exists("g:aniseed#env")
  let s:opts = get(g:, "aniseed#env")

  if type(s:opts) == 6 && s:opts == v:true
    s:opts = {}
  endif

  call luaeval("require('aniseed.env').init(_A)", s:opts)
end
