module Elm.RandomNumber exposing (randomListOfIntAfterInitialClick)

import Elm.Constants exposing (..)
import Random
import Random.List


randomListOfIntAfterInitialClick : List Int -> Random.Generator (List Int)
randomListOfIntAfterInitialClick listOfNumbersToRemove =
    List.range 1 n_squares
        |> List.filter (isNotInList listOfNumbersToRemove)
        |> Random.List.shuffle
        |> Random.map (List.take n_bombs)


isNotInList : List Int -> Int -> Bool
isNotInList listOfNumbersToRemove int =
    if List.member int listOfNumbersToRemove then
        False

    else
        True
