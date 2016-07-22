module Main exposing (..)

import ElmTest exposing (..)

import Test.ArrayList as ArrayList



tests : Test
tests =
    suite "ArrayList Tests"
        [ ArrayList.tests
        ]


main =
    runSuite tests
