#!/usr/bin/env bash

# Executes all of your tests found in test/fnl using the Aniseed cloned by dep.sh.
# Will leave behind files in test/lua and test/results.txt that you'll want to gitignore.
# All test modules must end with -test (so the file names need to end with -test.fnl).
# Environment (optional): PREFIX (first-ish arg to nvim), SUFFIX (last arg to nvim)
# Usage: PREFIX="-c 'syntax on'" SUFFIX="foo.clj" deps/aniseed/scripts/test.sh

nvim -u NONE \
    $PREFIX \
    -c "let &runtimepath = &runtimepath . ',' . getcwd()" \
    -c "let &runtimepath = &runtimepath . ',' . getcwd() . 'deps/aniseed'" \
    -c "let &runtimepath = &runtimepath . ',' . getcwd() . '/test'" \
    -c "lua require('aniseed.compile').glob('**/*.fnl', 'test/fnl', 'test/lua', {force = true})" \
    -c "lua require('aniseed.test').suite()" \
    $SUFFIX

EXIT_CODE=$?
cat test/results.txt
exit $EXIT_CODE
