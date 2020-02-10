.PHONY: compile test deps

SRC_FILES := $(basename $(shell find fnl -type f -name "*.fnl" ! -name "macros.fnl" -printf '%P\n'))

compile:
	rm -rf lua
	for f in $(SRC_FILES); do \
		mkdir -p lua/$$(dirname $$f); \
		deps/Fennel/fennel scripts/internal/compile.fnl fnl/$$f.fnl > lua/$$f.lua; \
	done
	mkdir -p lua/aniseed/deps
	cp deps/Fennel/fennel.lua lua/aniseed/deps/fennel.lua
	cp deps/Fennel/fennelview.fnl.lua lua/aniseed/deps/view.lua
	cp deps/nvim.lua/lua/nvim.lua lua/aniseed/deps/nvim.lua

test:
	scripts/test.sh

deps:
	mkdir -p deps
	if [ ! -d "deps/Fennel" ]; then git clone https://github.com/bakpakin/Fennel.git deps/Fennel; fi
	cd deps/Fennel && git fetch && git checkout 0.3.2
	if [ ! -d "deps/nvim.lua" ]; then git clone https://github.com/norcalli/nvim.lua.git deps/nvim.lua; fi
	cd deps/nvim.lua && git fetch && git checkout 5d57be0b6eea6c06977b1c5fe0752da909cf4154
