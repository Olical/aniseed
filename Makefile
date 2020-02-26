.PHONY: compile test deps

SRC_FILES := $(basename $(shell find fnl -type f -name "*.fnl" ! -name "macros.fnl" -printf '%P\n'))

compile:
	rm -rf lua
	for f in $(SRC_FILES); do \
		mkdir -p lua/$$(dirname $$f); \
		deps/Fennel/fennel scripts/internal/compile.fnl fnl/$$f.fnl > lua/$$f.lua; \
	done
	mkdir -p lua/aniseed/deps
	cp fnl/aniseed/macros.fnl lua/aniseed
	cp deps/Fennel/fennel.lua lua/aniseed/deps/fennel.lua
	cp deps/Fennel/fennelview.fnl.lua lua/aniseed/deps/fennelview.lua
	cp deps/nvim.lua/lua/nvim.lua lua/aniseed/deps/nvim.lua

test:
	SUFFIX="test/fnl/foo.fnl" scripts/test.sh

deps:
	scripts/dep.sh bakpakin Fennel 0.3.2
	scripts/dep.sh norcalli nvim.lua 5d57be0b6eea6c06977b1c5fe0752da909cf4154
