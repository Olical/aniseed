.PHONY: compile test deps

SRC_FILES := $(basename $(shell find fnl -type f -name "*.fnl" -printf '%P\n'))

compile: deps
	rm -rf lua
	for f in $(SRC_FILES); do \
		mkdir -p lua/$$(dirname $$f); \
		deps/Fennel/fennel --compile fnl/$$f.fnl > lua/$$f.lua; \
	done
	cp deps/Fennel/fennel.lua lua/aniseed/fennel.lua
	cp deps/Fennel/fennelview.fnl.lua lua/aniseed/view.lua
	cp deps/nvim.lua/lua/nvim.lua lua/aniseed/nvim.lua

deps:
	mkdir -p deps
	if [ ! -d "deps/Fennel" ]; then git clone https://github.com/bakpakin/Fennel.git deps/Fennel; fi
	cd deps/Fennel && git checkout 0.3.0
	if [ ! -d "deps/nvim.lua" ]; then git clone https://github.com/norcalli/nvim.lua.git deps/nvim.lua; fi
	cd deps/nvim.lua && git checkout eef6138d13629643577aa4c56f3151247b9fe9bb

test: compile
	rm -rf test/lua
	nvim -u NONE \
		-c "let &runtimepath = expand('<sfile>:p:h').','.expand('<sfile>:p:h').'/test,'.&runtimepath" \
		-c "lua require('aniseed.compile').glob('**/*.fnl', 'test/fnl', 'test/lua', {force = true}) require('aniseed.mapping').init() require('foo')" \
		test/fnl/foo.fnl
