(local core (require :aniseed.core))

(fn print-msg [msg]
  (print (.. "Message: " msg)))

(core.module
  :bar.baz
  {:print-msg print-msg})
