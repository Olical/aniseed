FROM cimg/base:2024.07

RUN mkdir -p ~/bin ~/nvim && \
    cd ~/nvim && \
    curl -L https://github.com/neovim/neovim/releases/download/v0.10.0/nvim.appimage -o nvim.appimage && \
    chmod +x ./nvim.appimage && \
    ./nvim.appimage --appimage-extract && \
    ln -s ~/nvim/squashfs-root/usr/bin/nvim ~/bin/nvim
