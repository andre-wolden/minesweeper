module Elm.MatrixAddBombNeighbouringNumber exposing
    ( caseItProper
    , maybeGetASquareAt
    , updateMatrixWithBombNeighbouringNumbers
    )

import Array exposing (..)
import Elm.Constants as C
import Elm.GenerateMatrixWithBombs exposing (..)
import Elm.Messages exposing (Msg(..))
import Elm.Model exposing (Model)
import Elm.RandomNumber exposing (..)
import Elm.Types exposing (Matrix, Square, SquareContent(..))
import Random


updateMatrixWithBombNeighbouringNumbers : Matrix -> Matrix
updateMatrixWithBombNeighbouringNumbers matrix =
    Array.map (doThisForEachColumn matrix) matrix


doThisForEachColumn : Matrix -> Array Square -> Array Square
doThisForEachColumn matrix column =
    Array.map (doThisForEachSquareInColumn matrix) column


doThisForEachSquareInColumn : Matrix -> Square -> Square
doThisForEachSquareInColumn matrix current_square =
    let
        i =
            current_square.i

        j =
            current_square.j

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

        listOfNeighbouringSquares : List (Maybe Square)
        listOfNeighbouringSquares =
            [ up_left, up_up, up_right, left_left, right_right, down_left, down_down, down_right ]

        numberOfBooombNeighbours : Int
        numberOfBooombNeighbours =
            List.foldr plusOneIfBombSquare 0 listOfNeighbouringSquares

        newSquare =
            { current_square | n_nabo_miner = numberOfBooombNeighbours }
    in
    case newSquare.square_content of
        BOOOMB ->
            newSquare

        _ ->
            case newSquare.n_nabo_miner of
                0 ->
                    newSquare

                _ ->
                    { newSquare | square_content = ANumber numberOfBooombNeighbours }


plusOneIfBombSquare : Maybe Square -> Int -> Int
plusOneIfBombSquare maybeSquare int =
    case maybeSquare of
        Just aSquare ->
            case aSquare.square_content of
                BOOOMB ->
                    int + 1

                _ ->
                    int

        Nothing ->
            int


maybeGetASquareAt : Int -> Int -> Matrix -> Maybe Square
maybeGetASquareAt i j matrix =
    Array.get (i - 1) matrix
        |> caseItProper j


caseItProper : Int -> Maybe (Array Square) -> Maybe Square
caseItProper j maybeColumn =
    case maybeColumn of
        Just aColumn ->
            Array.get (j - 1) aColumn

        Nothing ->
            Nothing



-- END
