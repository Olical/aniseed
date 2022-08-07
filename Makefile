.PHONY: deps compile test

SRC_FILES := $(basename $(shell find fnl -type f -name "*.fnl" ! -name "macros.fnl" | cut -d'/' -f2-))

default: deps compile test

deps:
	scripts/dep.sh bakpakin Fennel 21c429235d49b2908c7e46442660b6f22da90efc
	scripts/dep.sh norcalli nvim.lua 5d57be0b6eea6c06977b1c5fe0752da909cf4154
	LUA=luajit cd deps/Fennel && make build

compile:
	rm -rf lua
	for f in $(SRC_FILES); do \
		mkdir -p lua/$$(dirname $$f); \
		luajit deps/Fennel/fennel scripts/internal/compile.fnl fnl/$$f.fnl > lua/$$f.lua; \
	done
	mkdir -p lua/aniseed/deps
	cp fnl/aniseed/macros.fnl lua/aniseed
	cp deps/Fennel/fennel.lua lua/aniseed/deps/fennel.lua
	cp deps/nvim.lua/lua/nvim.lua lua/aniseed/deps/nvim.lua
	sed -i "s/\"fennel\./\"aniseed.fennel./gI" lua/aniseed/deps/fennel.lua

test:
	SUFFIX="test/fnl/foo.fnl" scripts/test.sh
