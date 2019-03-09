module Elm.MatrixUtils exposing (generateDefaultMatrix, getNeighbours)

import Array exposing (..)
import Elm.Constants as C
import Elm.MatrixAddBombNeighbouringNumber exposing (maybeGetASquareAt)
import Elm.Types exposing (Matrix, Square, SquareContent(..), SquareViewState(..))



-- 1, 2, 3
-- 4, 5, 6
-- 7, 8, 9


getNeighbours : Matrix -> Int -> Int -> Array.Array (Maybe Square)
getNeighbours matrix i j =
    let
        up_left : Maybe Square
        up_left =
            maybeGetASquareAt (i - 1) (j - 1) matrix

        up_up : Maybe Square
        up_up =
            maybeGetASquareAt i (j - 1) matrix

        up_right : Maybe Square
        up_right =
            maybeGetASquareAt (i + 1) (j - 1) matrix

        left_left : Maybe Square
        left_left =
            maybeGetASquareAt (i - 1) j matrix

        right_right : Maybe Square
        right_right =
            maybeGetASquareAt (i + 1) j matrix

        down_left : Maybe Square
        down_left =
            maybeGetASquareAt (i - 1) (j + 1) matrix

        down_down : Maybe Square
        down_down =
            maybeGetASquareAt i (j + 1) matrix

        down_right : Maybe Square
        down_right =
            maybeGetASquareAt (i + 1) (j + 1) matrix

        center_center : Maybe Square
        center_center =
            maybeGetASquareAt i j matrix
    in
    Array.fromList [ up_left, up_up, up_right, left_left, right_right, down_left, down_down, down_right, center_center ]


generateDefaultMatrix : Int -> Int -> Matrix
generateDefaultMatrix n_columns n_rows =
    generateMatrixAndPopulateWithBaseSquare n_columns n_rows
        |> addIJIDtoMatrix



-- Generate Default Matrix Without Bomb. At first click, must get "JustAnEmptySquare"


generateMatrixAndPopulateWithBaseSquare : Int -> Int -> Matrix
generateMatrixAndPopulateWithBaseSquare n_columns n_rows =
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


addIJIDtoMatrix : Matrix -> Matrix
addIJIDtoMatrix defaultMatrix =
    Array.indexedMap updateColumn defaultMatrix


updateColumn : Int -> Array Square -> Array Square
updateColumn column_index array_square =
    Array.indexedMap (updateSquareInRow column_index) array_square


updateSquareInRow : Int -> Int -> Square -> Square
updateSquareInRow column_index row_index aSquare =
    let
        currentSquareId =
            calculateSquareId row_index column_index
    in
    { id = currentSquareId
    , i = column_index + 1
    , j = row_index + 1
    , square_content = JustAnEmptySquare
    , n_nabo_miner = 0
    , squareViewState = SquareViewStateClosed
    }


calculateSquareId : Int -> Int -> Int
calculateSquareId row_index column_index =
    C.n_columns * row_index + column_index + 1
