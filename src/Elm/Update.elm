module Elm.Update exposing (update)

import Array exposing (..)
import Elm.Constants as C
import Elm.GenerateMatrixWithBombs exposing (..)
import Elm.Messages exposing (Msg(..))
import Elm.Model exposing (Model)
import Elm.RandomNumber exposing (..)
import Elm.Types exposing (AntallNaboMiner(..), Matrix, Square, SquareContent(..))
import Random


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )

        GenerateListOfRandomNumbersForNBombs ->
            ( model, Random.generate GotBombList randomListOfInt )

        GotBombList bombList ->
            let
                sorted_bomb_list : Maybe (List Int)
                sorted_bomb_list =
                    Just (List.sort bombList)

                matrix_with_bombs : Matrix
                matrix_with_bombs =
                    generateMatrixWithBombs bombList C.n_columns C.n_rows

                matrix_with_neighbour_number : Matrix
                matrix_with_neighbour_number =
                    updateMatrixWithBombNeighbouringNumbers matrix_with_bombs
            in
            ( { model | matrix = matrix_with_bombs }, Cmd.none )


updateMatrixWithBombNeighbouringNumbers : Matrix -> Matrix
updateMatrixWithBombNeighbouringNumbers matrix =
    Array.map (doThisForEachColumn matrix) matrix


doThisForEachColumn : Matrix -> Array Square -> Array Square
doThisForEachColumn matrix column =
    Array.map (doThisForEachSquareInColumn matrix) column


doThisForEachSquareInColumn : Matrix -> Square -> Square
doThisForEachSquareInColumn matrix current_square =
    current_square



-- let
--     i = current_square.i
--     j = current_square.j
--
--     up_left = isItABombAtThisPosition (i-1) j matrix
--     up_up = isItABombAtThisPosition i j matrix
--     up_right = isItABombAtThisPosition i j matrix
--     left_left = isItABombAtThisPosition i j matrix
--     right_right = isItABombAtThisPosition i j matrix
--     down_left = isItABombAtThisPosition i j matrix
--     down_down = isItABombAtThisPosition i j matrix
--     down_right = isItABombAtThisPosition i j matrix
-- in
-- END
