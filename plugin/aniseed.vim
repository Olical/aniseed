set lispwords+=module

if exists("g:aniseed#env")
  call luaeval("require('aniseed.env').init(_A)", get(g:, "aniseed#env"))
end
