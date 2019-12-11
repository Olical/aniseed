.PHONY: compile test deps

SRC_FILES := $(basename $(shell find fnl -type f -name "*.fnl" -printf '%P\n'))

compile:
	rm -rf lua
	for f in $(SRC_FILES); do \
		mkdir -p lua/$$(dirname $$f); \
		luajit deps/Fennel/fennel --compile fnl/$$f.fnl > lua/$$f.lua; \
	done
	cp deps/Fennel/fennel.lua lua/aniseed/fennel.lua
	cp deps/Fennel/fennelview.fnl.lua lua/aniseed/view.lua
	cp deps/nvim.lua/lua/nvim.lua lua/aniseed/nvim.lua

test: compile
	rm -rf test/lua
	nvim -u NONE \
		-c "let &runtimepath = &runtimepath . ',' . getcwd() . ',' . getcwd() . '/test'" \
		-c "lua require('aniseed.compile').glob('**/*.fnl', 'test/fnl', 'test/lua', {force = true}) " \
		-c "lua require('aniseed.test-suite').main()" \
		test/fnl/foo.fnl; \
		EXIT_CODE=$$?; \
		cat test/results.txt; \
		exit $$EXIT_CODE

deps:
	mkdir -p deps
	if [ ! -d "deps/Fennel" ]; then git clone https://github.com/bakpakin/Fennel.git deps/Fennel; fi
	cd deps/Fennel && git fetch && git checkout 0.3.0
	if [ ! -d "deps/nvim.lua" ]; then git clone https://github.com/norcalli/nvim.lua.git deps/nvim.lua; fi
	cd deps/nvim.lua && git fetch && git checkout 2af9792aee503467855ebd92ccdd9b971236216f
