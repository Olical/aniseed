(module aniseed.setup
  {autoload {nvim aniseed.nvim
             a aniseed.core
             eval aniseed.eval
             env aniseed.env
             antifennel aniseed.antifennel}})

(defn init []
  (when (= 1 (nvim.fn.has "nvim-0.7"))
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
        (let [code (a.slurp
                     (if (= "" cmd.args)
                       (nvim.buf_get_name (nvim.get_current_buf))
                       cmd.args))]
          (if code
            (let [(ok? res) (eval.str code {})]
              (if ok?
                (nvim.echo res)
                (nvim.err_writeln res)))
            (nvim.err_writeln (.. "File '" (or cmd.args "nil") "' not found")))))
      {:nargs :?
       :complete :file})

    (nvim.create_user_command
      :AniseedAntifennelBuffer
      antifennel.lua_antifennel
      {})

    (nvim.create_user_command
      :AniseedAntiluaBuffer
      antifennel.fnl_antilua
      {}))

  (when nvim.g.aniseed#env
    (env.init nvim.g.aniseed#env)))
