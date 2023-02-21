(module aniseed.antifennel
  {autoload {a aniseed.core
             str aniseed.string
             compile aniseed.compile
             antifnl aniseed.deps.antifennel}})

(defn- get_popup_size [hr wr]
  "Get window size for the given height and width ratios"
  (let [screen_w vim.o.columns
        screen_h (- vim.o.lines vim.o.cmdheight)
        window_w (math.floor (* screen_w wr))
        window_h (math.floor (* screen_h hr))
        center_x (/ (- screen_w window_w) 2)
        center_y (/ (- screen_h window_h) 2)]
    {:col center_x
     :row (- center_y vim.o.cmdheight)
     :height window_h
     :width  window_w}))

(defn fnl_antilua []
  "Display lua source from fennel"
  (if (= vim.o.filetype :fennel)
    (let [(_ result) (-> (str.join "\n" (vim.api.nvim_buf_get_lines 0 0 -1 true))
                         (compile.str {}))
          content (str.split result "\n")
          win-opts (a.merge! {:relative :editor :border :double}
                             (get_popup_size 0.8 0.6))
          map-opts {:noremap true :silent true}
          bufnr (vim.api.nvim_create_buf false false)
          winnr (vim.api.nvim_open_win bufnr 0 win-opts)]
      (vim.api.nvim_buf_set_lines  bufnr 0 -1 false content) 
      (vim.api.nvim_buf_set_option bufnr :filetype :lua)
      (vim.api.nvim_buf_set_option bufnr :buftype  :nofile)
      (vim.api.nvim_buf_set_keymap bufnr :n :q     ":bdelete<CR>" map-opts)
      (vim.api.nvim_buf_set_keymap bufnr :n :<ESC> ":bdelete<CR>" map-opts)
      (vim.api.nvim_win_set_option winnr :winhl "Normal:NormalFloat"))))

(defn lua_antifennel []
  "Display fennel code from lua"
  (if (= vim.o.filetype :lua)
    (let [(_ result) (->> (vim.api.nvim_buf_get_lines 0 0 -1 true)
                          (str.join "\n")
                          (pcall antifnl))
          content (str.split result "\n")
          win-opts (a.merge! {:relative :editor :border :double}
                             (get_popup_size 0.8 0.6))
          map-opts {:noremap true :silent true}
          bufnr (vim.api.nvim_create_buf false false)
          winnr (vim.api.nvim_open_win bufnr 0 win-opts)]
      (vim.api.nvim_buf_set_lines  bufnr 0 -1 false content) 
      (vim.api.nvim_buf_set_option bufnr :filetype :fennel)
      (vim.api.nvim_buf_set_option bufnr :buftype  :nofile)
      (vim.api.nvim_buf_set_keymap bufnr :n :q     ":bdelete<CR>" map-opts)
      (vim.api.nvim_buf_set_keymap bufnr :n :<ESC> ":bdelete<CR>" map-opts)
      (vim.api.nvim_win_set_option winnr :winhl "Normal:NormalFloat"))))

