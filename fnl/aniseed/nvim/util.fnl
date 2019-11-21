(local nvim (require :aniseed.nvim))

(fn normal [keys]
  "Execute some command as if you were in normal mode silently."
  (nvim.ex.silent (.. "exe \"normal! " keys "\"")))

(fn fn-bridge [viml-name module lua-name opts]
  "Creates a VimL function that calls through to a Lua function in the named module.
  Takes an optional opts table, if that contains `:range true` it'll plumb the
  range start and end into the function call's first two arguments."
  (let [{:range range} (or opts {})]
    (nvim.ex.function_
      (.. viml-name
          "(...)" 
          (if range
            " range"
            "")
          "
          call luaeval(\"require('" module "')['" lua-name "']("
          (if range
            "\" . a:firstline . \", \" . a:lastline . \", "
            "")
          "unpack(_A))\", a:000)
          endfunction"))))

{:aniseed/module :aniseed.nvim.util
 :normal normal
 :fn-bridge fn-bridge}
