@echo off

elm-package install -y

elm-make --yes --output tests.js Test.elm
node tests.js