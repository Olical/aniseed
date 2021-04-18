#!/usr/bin/env bash

# Compiles all Fennel code into Lua assuming you have Aniseed cloned through dep.sh.
# Usage: deps/aniseed/scripts/compile.sh

# Enable "light" Aniseed modules. This reduces the amount of code produced by
# the aniseed.macros module support. This means your Lua modules on disk will
# be vanilla Lua modules, without all of Aniseed's extra metadata. This means
# some initial interactive evaluations of your code may fail but will be fine
# after a <prefix>ef or <prefix>eb which recompiles with all metadata enabled.
export ANISEED_LIGHT=1

nvim --headless -u NONE \
    -c "let &runtimepath = &runtimepath . ',deps/aniseed,' . getcwd()" \
    -c "lua require('aniseed.compile').glob('**/*.fnl', 'fnl', 'lua')" \
    +q
