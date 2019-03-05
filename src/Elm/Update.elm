module Elm.Update exposing (update)

import Array exposing (..)
import Elm.Constants exposing (n_bombs)
import Elm.Messages exposing (Msg(..))
import Elm.Model exposing (Model)
import Elm.RandomNumber exposing (..)
import Elm.Types exposing (Matrix, Square, SquareContent(..))
import Random


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )

        GenerateListOfRandomNumbersForNBombs ->
            ( model, Random.generate GotBombList randomListOfInt )

        GotBombList bombList ->
            update NowGenerateAllTheSquares { model | bombList = Just bombList }

        NowGenerateAllTheSquares ->
            case model.bombList of
                Just bombList ->
                    ( { model | matrix = generateMatrix bombList model.board.n_columns model.board.n_rows }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )



-- GENERATING SQUARES STUFF


generateMatrix : List Int -> Int -> Int -> Matrix
generateMatrix bombList n_columns n_rows =
    getDefaultMatrix n_columns n_rows
        |> updateMatrixWithInfo bombList


updateMatrixWithInfo : List Int -> Matrix -> Matrix
updateMatrixWithInfo bombList defaultMatrix =
    Array.indexedMap updateColumn defaultMatrix


updateColumn : Int -> Array Square -> Array Square
updateColumn column_index array_square =
    Array.indexedMap (updateSquareInRow column_index) array_square


updateSquareInRow : Int -> Int -> Square -> Square
updateSquareInRow column_index row_index aSquare =
    { id = 0, i = column_index, j = row_index, square_content = JustAnEmptySquare }


getDefaultMatrix : Int -> Int -> Matrix
getDefaultMatrix n_columns n_rows =
    Array.repeat n_columns baseSquare
        |> Array.repeat n_rows


baseSquare : Square
baseSquare =
    { id = 0, i = 0, j = 0, square_content = JustAnEmptySquare }


generateSquare : Int -> Int -> Int -> SquareContent -> Square
generateSquare id i j square_content =
    { id = id
    , i = i -- Column
    , j = j -- Row
    , square_content = square_content
    }
