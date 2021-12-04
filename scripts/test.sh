#!/usr/bin/env bash

# Executes all of your tests found in test/fnl using the Aniseed cloned by dep.sh.
# Will leave behind files in test/lua that you'll want to gitignore.
# All test modules must end with -test (so the file names need to end with -test.fnl).
# Environment (optional): PREFIX (first-ish arg to nvim), SUFFIX (last arg to nvim)
# Usage: PREFIX="-c 'syntax on'" SUFFIX="foo.clj" deps/aniseed/scripts/test.sh

nvim --headless -u NONE \
    $PREFIX \
    -c "set noswapfile" \
    -c "let &runtimepath = &runtimepath . ',' . getcwd()" \
    -c "let &runtimepath = &runtimepath . ',' . getcwd() . '/test'" \
    -c "let &runtimepath = &runtimepath . ',' . getcwd() . '/deps/aniseed'" \
    -c "lua package.path = package.path .. ';$(pwd)/lua/?.lua;$(pwd)/test/lua/?.lua;$(pwd)/deps/aniseed/lua/?.lua'" \
    -c "lua require('aniseed.compile').glob('**/*.fnl', 'test/fnl', 'test/lua')" \
    -c "lua require('aniseed.test').suite()" \
    $SUFFIX

EXIT_CODE=$?
echo
exit $EXIT_CODE
