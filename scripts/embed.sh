#!/usr/bin/env bash

# Copies a dependency's Lua from deps (result of dep.sh) into your own Lua
# directory under a prefix directory. Then munges the dependency to (hopefully)
# replace all occurrences of the module paths with your unique project specific prefix.
# This, in most cases, should prevent your version conflicting with
# other plugins. It might however completely break the Lua, so use at your own risk.
# Should be totally safe with Aniseed but this script makes a LOT of assumptions.
# Args: Dependency name, your project module prefix, optional src dir.
# Usage: deps/aniseed/scripts/embed.sh aniseed your-plugin-name
# Usage (with src): deps/aniseed/scripts/embed.sh sha1 your-plugin-name src/sha1/

mkdir -p "lua/$2"
rsync -avu --delete "deps/$1/${3:-lua/$1/}" "lua/$2/$1"
find "lua/$2/$1" -type f -name "*.lua" -exec sed -i "s/\"$1\./\"$2.$1./g" {} \;
