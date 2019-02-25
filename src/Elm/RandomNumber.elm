module Elm.RandomNumber exposing (randomNumber)

import Elm.Constants exposing (..)
import Random


randomNumber : Random.Generator Int
randomNumber =
    Random.int 1 n_squares
