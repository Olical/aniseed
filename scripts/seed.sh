#!/usr/bin/env bash

# Sets up a new Aniseed plugin project within the current directory.
# Warning: Only run in new empty directories, it will replace your
# `.gitignore`, `Makefile` and other such files!
# Warning: Requires `make` as part of the workflow.
# Usage: curl -fL https://raw.githubusercontent.com/Olical/aniseed/master/scripts/seed.sh | sh

plug_name=${PWD##*/}
if [[ $plug_name == *"."* ]]
then
    printf "ERROR: Invalid plugin name '$plug_name'. Dots (.) are not allowed.\n"
    exit 1
fi

mkdir -p scripts

printf "$(tput bold)Downloading Aniseed dependency manager script...\n\n"
curl -fL https://raw.githubusercontent.com/Olical/aniseed/master/scripts/dep.sh -o scripts/dep.sh 2>/dev/null;
chmod +x scripts/dep.sh

printf "Fetching Aniseed...\n\n"
scripts/dep.sh Olical aniseed origin/master 2>/dev/null;

printf "Creating your new plugin...\n\n"
cp -r deps/aniseed/seed/* .
cp deps/aniseed/seed/.gitignore .
mv ./fnl/example ./fnl/$plug_name
mv ./test/fnl/example ./test/fnl/$plug_name
mv ./plugin/example.vim ./plugin/$plug_name.vim
sed -i -e "s/example/$plug_name/g" ./test/fnl/$plug_name/main-test.fnl
sed -i -e "s/example/$plug_name/g" ./fnl/$plug_name/main.fnl
sed -i -e "s/example/$plug_name/g" ./plugin/$plug_name.vim
sed -i -e "s/example/$plug_name/g" ./Makefile

printf "$(tput bold)Running Makefile...$(tput sgr0)\n\n"
make -s &
wait

printf "\nDone, $(tput bold)Happy dev.\n\n"

if command -v tree &> /dev/null
then
  tree -I 'aniseed'
fi
