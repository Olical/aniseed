#!/usr/bin/env bash

# Compiles all Fennel code into Lua assuming you have Aniseed cloned through dep.sh.
# Usage: deps/aniseed/scripts/compile.sh
# Usage: ANISEED_EMBED_PREFIX=my-plugin-name deps/aniseed/scripts/compile.sh

nvim --headless -u NONE \
    -c "let &runtimepath = &runtimepath . ',deps/aniseed,' . getcwd()" \
    -c "lua package.path = package.path .. ';$(pwd)/lua/?.lua;deps/aniseed/lua/?.lua'" \
    -c "lua require('aniseed.compile').glob('**/*.fnl', 'fnl', 'lua')" \
    +q

if [ -n "$ANISEED_EMBED_PREFIX" ]; then
    find "lua/$ANISEED_EMBED_PREFIX" -type f -name "*.lua" -exec sed -i.aniseed_bak "s/\"aniseed\./\"$ANISEED_EMBED_PREFIX.aniseed./g" {} \;
    find "lua/$ANISEED_EMBED_PREFIX" -type f -name "*.fnl" -exec sed -i.aniseed_bak "s/\"aniseed\./\"$ANISEED_EMBED_PREFIX.aniseed./g" {} \;
    find . -type f -name '*.aniseed_bak' -delete
fi
