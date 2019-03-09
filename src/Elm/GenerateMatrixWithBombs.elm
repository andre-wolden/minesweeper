module Elm.GenerateMatrixWithBombs exposing (generateMatrixWithBombs)

import Array exposing (..)
import Elm.Constants as C
import Elm.Types exposing (Matrix, Square, SquareContent(..), SquareViewState(..))


generateMatrixWithBombs : List Int -> Int -> Int -> Matrix
generateMatrixWithBombs bombList n_columns n_rows =
    getDefaultMatrix n_columns n_rows
        |> updateMatrixWithInfo bombList


updateMatrixWithInfo : List Int -> Matrix -> Matrix
updateMatrixWithInfo bombList defaultMatrix =
    Array.indexedMap (updateColumn bombList) defaultMatrix


updateColumn : List Int -> Int -> Array Square -> Array Square
updateColumn bombList column_index array_square =
    Array.indexedMap (updateSquareInRow bombList column_index) array_square


updateSquareInRow : List Int -> Int -> Int -> Square -> Square
updateSquareInRow bombList column_index row_index aSquare =
    let
        currentSquareId =
            calculateSquareId row_index column_index
    in
    { id = currentSquareId
    , i = column_index + 1
    , j = row_index + 1
    , square_content = setBombIfBomb bombList currentSquareId
    , n_nabo_miner = 3
    , squareViewState = SquareViewStateClosed
    }


calculateSquareId : Int -> Int -> Int
calculateSquareId row_index column_index =
    C.n_columns * row_index + column_index + 1


setBombIfBomb : List Int -> Int -> SquareContent
setBombIfBomb intList squareId =
    if List.any (\el -> el == squareId) intList then
        BOOOMB

    else
        JustAnEmptySquare


getDefaultMatrix : Int -> Int -> Matrix
getDefaultMatrix n_columns n_rows =
    Array.repeat n_columns baseSquare
        |> Array.repeat n_rows


baseSquare : Square
baseSquare =
    { id = 0
    , i = 0
    , j = 0
    , square_content = JustAnEmptySquare
    , n_nabo_miner = 0
    , squareViewState = SquareViewStateClosed
    }
