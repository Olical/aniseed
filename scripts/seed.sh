#!/usr/bin/env sh

# Sets up a new Aniseed plugin project within the current directory.
# Warning: Only run in new empty directories, it will replace your
# `.gitignore`, `Makefile` and other such files!
# Warning: Requires `make` as part of the workflow.
# Usage: curl -fL https://raw.githubusercontent.com/Olical/aniseed/master/scripts/seed.sh | sh

mkdir -p scripts
curl -fL https://raw.githubusercontent.com/Olical/aniseed/master/scripts/dep.sh -o scripts/dep.sh
chmod +x scripts/dep.sh
scripts/dep.sh Olical aniseed origin/master
cp -r deps/aniseed/seed/* .
cp deps/aniseed/seed/.gitignore .
make
