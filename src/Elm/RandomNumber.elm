module Elm.RandomNumber exposing (randomListOfInt, randomNumber)

import Elm.Constants exposing (..)
import Random
import Random.List


randomNumber : Random.Generator Int
randomNumber =
    Random.int 1 n_squares


randomListOfInt : Random.Generator (List Int)
randomListOfInt =
    List.range 0 n_squares
        |> Random.List.shuffle
        |> Random.map (List.take n_bombs)
