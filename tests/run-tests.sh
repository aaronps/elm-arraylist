#!/bin/sh

cd "$(dirname "$0")"
set -e

elm-package install -y

elm-make --yes --output tests.js Test.elm
node tests.js
