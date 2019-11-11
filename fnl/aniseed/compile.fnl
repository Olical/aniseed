(local core (require :aniseed.core))
(local nvim (require :aniseed.nvim))
(local fennel (require :aniseed.fennel))

(fn glob [src-expr dest]
  "Compiles all files that match the glob expr as Fennel into Lua. Finds the
  shallowest common ancestor the glob matches then writes the Lua files into
  the same shape tree as the src but in dest."
  (nvim.call-function :glob src-expr true true))

{:glob glob}
