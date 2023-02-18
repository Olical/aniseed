.PHONY: deps compile test

SRC_FILES := $(basename $(shell find fnl -type f -name "*.fnl" | cut -d'/' -f2-))

default: deps compile test

deps:
	scripts/dep.sh bakpakin Fennel bf0bf069a77d8bced86468b918560b06f0b7ca94
	scripts/dep.sh norcalli nvim.lua 5d57be0b6eea6c06977b1c5fe0752da909cf4154
	scripts/dep.sh luafun luafun cb6a7e25d4b55d9578fd371d1474b00e47bd29f3
	LUA=luajit cd deps/Fennel && make build

compile:
	rm -rf lua
	for f in $(SRC_FILES); do \
		if [[ $$f != *macro* ]]; then \
			mkdir -p lua/$$(dirname $$f); \
			luajit deps/Fennel/fennel scripts/internal/compile.fnl fnl/$$f.fnl > lua/$$f.lua; \
		fi \
	done
	mkdir -p lua/aniseed/deps
	mkdir -p lua/aniseed/macros
	cp fnl/aniseed/macros.fnl lua/aniseed
	cp fnl/aniseed/macros/*.fnl lua/aniseed/macros
	cp deps/Fennel/fennel.lua lua/aniseed/deps/fennel.lua
	cp deps/luafun/fun.lua lua/aniseed/deps/fun.lua
	cp deps/nvim.lua/lua/nvim.lua lua/aniseed/deps/nvim.lua
	sed -i "s/\"fennel\./\"aniseed.fennel./gI" lua/aniseed/deps/fennel.lua

test:
	SUFFIX="test/fnl/foo.fnl" scripts/test.sh
