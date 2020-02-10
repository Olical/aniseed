#!/usr/bin/env bash

nvim -u NONE \
    -c "set rtp+=deps/aniseed" \
    -c "lua require('aniseed.compile').glob('**/*.fnl', 'fnl', 'lua')" \
    +q
