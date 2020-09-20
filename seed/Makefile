.PHONY: deps compile test

default: deps compile test

deps:
	scripts/dep.sh Olical aniseed origin/master

compile:
	rm -rf lua
	deps/aniseed/scripts/compile.sh
	## comment out if you don't need access to Aniseed at runtime.
	deps/aniseed/scripts/embed.sh aniseed example

test:
	rm -rf test/lua
	deps/aniseed/scripts/test.sh
