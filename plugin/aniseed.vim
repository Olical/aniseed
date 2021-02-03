set lispwords+=module

if exists("g:aniseed#env")
  let s:opts = get(g:, "aniseed#env")
  call luaeval("require('aniseed.env').init(_A)", s:opts == v:true ? {} : s:opts)
end
