.PHONY: deps compile test

default: deps compile test

deps:
	scripts/dep.sh Olical aniseed origin/master

compile:
	rm -rf lua
	deps/aniseed/scripts/compile.sh

	# Remove this if you only want Aniseed at compile time.
	deps/aniseed/scripts/embed.sh aniseed example

test:
	rm -rf test/lua
	deps/aniseed/scripts/test.sh
