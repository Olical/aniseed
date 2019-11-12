.PHONY: compile test

SRC_FILES := $(basename $(shell find fnl -type f -name "*.fnl" -printf '%P\n'))

compile:
	rm -rf lua
	for f in $(SRC_FILES); do \
		mkdir -p lua/$$(dirname $$f); \
		submodules/Fennel/fennel --compile fnl/$$f.fnl > lua/$$f.lua; \
	done
	ln -s ../../submodules/Fennel/fennel.lua lua/aniseed/fennel.lua
	ln -s ../../submodules/Fennel/fennelview.fnl.lua lua/aniseed/view.lua
	ln -s ../../submodules/nvim.lua/lua/nvim.lua lua/aniseed/nvim.lua

test: compile
	rm -rf test/lua
	nvim -c "lua print(require('aniseed/view')(require('aniseed/compile').glob('**.fnl', 'test/fnl', 'test/lua', {force = true}))) require('foo')"
