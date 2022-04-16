(module aniseed.setup
  {autoload {nvim aniseed.nvim
             a aniseed.core
             eval aniseed.eval
             env aniseed.env}})

(defn init []
  (nvim.create_user_command
    :AniseedEval
    (fn [cmd]
      (let [(ok? res) (eval.str cmd.args {})]
        (if ok?
          (nvim.echo res)
          (nvim.err_writeln res))))
    {:nargs 1})

  (nvim.create_user_command
    :AniseedEvalFile
    (fn [cmd]
      (let [code (a.slurp cmd.args)]
        (if code
          (let [(ok? res) (eval.str code {})]
            (if ok?
              (nvim.echo res)
              (nvim.err_writeln res)))
          (nvim.err_writeln (.. "File '" (or cmd.args "nil") "' not found")))))
    {:nargs :?
     :complete :file})

  (when nvim.g.aniseed#env
    (env.init nvim.g.aniseed#env)))
