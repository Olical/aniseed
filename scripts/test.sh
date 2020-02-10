#!/usr/bin/env bash

rm -rf test/lua

nvim -u NONE \
    -c "let &runtimepath = &runtimepath . ',' . getcwd()" \
    -c "let &runtimepath = &runtimepath . ',' . getcwd() . '/test'" \
    -c "lua require('aniseed.compile').glob('**/*.fnl', 'test/fnl', 'test/lua', {force = true})" \
    -c "lua require('aniseed.test-suite').main()" \
    test/fnl/foo.fnl

EXIT_CODE=$?
cat test/results.txt
exit $EXIT_CODE
