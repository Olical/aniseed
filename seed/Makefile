.PHONY: deps compile test

default: deps compile test

deps:
	scripts/dep.sh Olical aniseed origin/master

compile:
	rm -rf lua
	deps/aniseed/scripts/compile.sh
	## Uncomment and set CHANGEME to your project prefix if you need access to
	## Aniseed at runtime, instead of just compile time.
	## If your project modules are like myplugin.some-thing, you'd use myplugin
	## in place of CHANGEME.
	# deps/aniseed/scripts/embed.sh aniseed CHANGEME

test:
	rm -rf test/lua
	deps/aniseed/scripts/test.sh
