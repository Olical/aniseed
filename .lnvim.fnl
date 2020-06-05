(module aniseed.lnvim
  {require {config conjure.config}})

(config.assoc
  {:client :fennel.aniseed
   :path [:aniseed-module-prefix]
   :val "aniseed."})
