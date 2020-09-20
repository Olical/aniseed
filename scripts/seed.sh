#!/usr/bin/env sh

# Sets up a new Aniseed plugin project within the current directory.
# Warning: Only run in new empty directories, it will replace your
# `.gitignore`, `Makefile` and other such files!
# Warning: Requires `make` as part of the workflow.
# Usage: curl -fL https://raw.githubusercontent.com/Olical/aniseed/master/scripts/seed.sh | sh

mkdir -p scripts
printf "$(tput bold)Downloading Aniseed Bootstrap script ...\n\n"
curl -fL https://raw.githubusercontent.com/Olical/aniseed/master/scripts/dep.sh -o scripts/dep.sh 2>/dev/null;
chmod +x scripts/dep.sh
printf "Cloning Aniseed repo ...\n\n"
scripts/dep.sh Olical aniseed origin/master 2>/dev/null; 
printf "Bootstrapping ...\n\n"
cp -r deps/aniseed/seed/* .
cp deps/aniseed/seed/.gitignore .
plug_name=${PWD##*/}   
mv ./fnl/example ./fnl/$plug_name
mv ./test/fnl/example ./test/fnl/$plug_name
mv ./plugin/example.vim ./plugin/$plug_name.vim
sed -i -e "s/example/$plug_name/g" ./test/fnl/$plug_name/main-test.fnl
sed -i -e "s/example/$plug_name/g" ./fnl/$plug_name/main.fnl
sed -i -e "s/example/$plug_name/g" ./plugin/$plug_name.vim
sed -i -e "s/example/$plug_name/g" ./Makefile
printf "$(tput bold)Running Makefile ...$(tput sgr0)\n\n"
make -s
printf "\nDone, $(tput bold)Happy dev.\n\n"; tree  -I 'aniseed'
