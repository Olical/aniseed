.PHONY: compile test

SRC_FILES := $(basename $(shell find fnl -type f -name "*.fnl" -printf '%P\n'))

compile:
	rm -rf lua
	for f in $(SRC_FILES); do \
		mkdir -p lua/$$(dirname $$f); \
		submodules/Fennel/fennel --compile fnl/$$f.fnl > lua/$$f.lua; \
	done
	ln -s ../../submodules/Fennel/fennel.lua lua/aniseed/fennel.lua
	ln -s ../../submodules/inspect.lua/inspect.lua lua/aniseed/inspect.lua

test: compile
	nvim -c "lua print(require('aniseed/inspect')(require('aniseed/compile').glob('test/fnl/**', 'test/lua')))"
