#!/usr/bin/env bash

# Compiles all Fennel code into Lua assuming you have Aniseed cloned through dep.sh.
# Usage: deps/aniseed/scripts/compile.sh

nvim -u NONE \
    -c "let &runtimepath = &runtimepath . ',deps/aniseed,' . getcwd()" \
    -c "lua require('aniseed.compile').glob('**/*.fnl', 'fnl', 'lua')" \
    +q
