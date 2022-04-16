(module aniseed.setup
  {autoload {nvim aniseed.nvim
             env aniseed.env}})

(defn init []
  (when nvim.g.aniseed#env
    (env.init nvim.g.aniseed#env)))
