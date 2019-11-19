(local nvim (require :aniseed.nvim))

(fn normal [keys]
  "Execute some command as if you were in normal mode silently."
  (nvim.ex.silent (.. "exe \"normal! " keys "\"")))

(fn fn-bridge [viml-name module lua-name]
  "Creates a VimL function that calls through to a Lua function in the named module."
  (nvim.ex.function_
    (.. viml-name
        "(...)
        call luaeval(\"require('" module "')['" lua-name "'](unpack(_A))\", a:000)
        endfunction")))

{:normal normal
 :fn-bridge fn-bridge}
