.PHONY: deps compile test

SRC_FILES := $(basename $(shell find fnl -type f -name "*.fnl" ! -name "macros.fnl" | cut -d'/' -f2-))

default: deps compile test

deps:
	scripts/dep.sh bakpakin Fennel 5c50dab274051cf8736b61153b1f9c7fb7d6b2bd
	scripts/dep.sh norcalli nvim.lua 5d57be0b6eea6c06977b1c5fe0752da909cf4154
	cd deps/Fennel && make build

compile:
	rm -rf lua
	for f in $(SRC_FILES); do \
		mkdir -p lua/$$(dirname $$f); \
		deps/Fennel/fennel scripts/internal/compile.fnl fnl/$$f.fnl > lua/$$f.lua; \
	done
	mkdir -p lua/aniseed/deps
	cp fnl/aniseed/macros.fnl lua/aniseed
	cp deps/Fennel/fennel.lua lua/aniseed/deps/fennel.lua
	cp deps/Fennel/fennelview.lua lua/aniseed/deps/fennelview.lua
	cp deps/nvim.lua/lua/nvim.lua lua/aniseed/deps/nvim.lua
	sed -i "s/\"fennel\./\"aniseed.fennel./gI" lua/aniseed/deps/fennel.lua

test:
	SUFFIX="test/fnl/foo.fnl" scripts/test.sh
