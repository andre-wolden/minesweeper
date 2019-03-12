module Elm.RecursiveOpening exposing (doTheTrickyPart)

import Elm.MatrixUtils exposing (getListOfEmptyNeighbours, openAllNeighbours)
import Elm.Messages exposing (..)
import Elm.Model exposing (..)
import Elm.Types exposing (..)


doTheTrickyPart : Model -> Square -> Matrix -> Int -> Bool -> ( Model, Cmd Msg )
doTheTrickyPart model justOpenedSquare matrix n_opened_so_far_updated isVictorious =
    let
        initialAlgDat : AlgDat
        initialAlgDat =
            { remaining = [] --: List Square
            , current_matrix = matrix --: Matrix
            , current_square = justOpenedSquare --: Square
            , done = [] --: List Square
            , debug_remaining = []
            }

        finishedAlgDat =
            goAgain initialAlgDat
    in
    ( { model
        | matrix = finishedAlgDat.current_matrix
        , n_opened_so_far = n_opened_so_far_updated
        , debug_remaining = finishedAlgDat.debug_remaining
        , gameState =
            if isVictorious then
                Victorious

            else
                InGame
      }
    , Cmd.none
    )


goAgain : AlgDat -> AlgDat
goAgain ag =
    let
        current_matrix =
            ag.current_matrix

        current_square =
            ag.current_square

        remaining =
            ag.remaining

        done =
            ag.done

        newEmptyNeighbours =
            getListOfEmptyNeighbours current_matrix current_square.i current_square.j

        matrix_updated =
            openAllNeighbours current_matrix current_square

        done_updated =
            current_square :: done

        remaining_updated =
            updateRemainingList remaining newEmptyNeighbours done

        current_square_updated =
            List.head remaining_updated
    in
    case current_square_updated of
        Nothing ->
            { remaining = remaining_updated --: List Square
            , current_matrix = matrix_updated --: Matrix
            , current_square = current_square --: Square
            , done = done_updated --: List Square
            , debug_remaining = newEmptyNeighbours
            }

        Just nextSquare ->
            goAgain
                { remaining = remaining_updated --: List Square
                , current_matrix = matrix_updated --: Matrix
                , current_square = nextSquare --: Square
                , done = done_updated --: List Square
                , debug_remaining = newEmptyNeighbours
                }


updateRemainingList : List Square -> List Square -> List Square -> List Square
updateRemainingList remaining newNeighbours done =
    newNeighbours
        |> List.filter (notInRemaining remaining)
        |> (++) remaining
        |> List.filter (notInDone done)


notInRemaining : List Square -> Square -> Bool
notInRemaining remaining aSquare =
    List.map squareToId remaining
        |> List.member aSquare.id
        |> not


notInDone : List Square -> Square -> Bool
notInDone done aSquare =
    List.map squareToId done
        |> List.member aSquare.id
        |> not


squareToId : Square -> Int
squareToId aSquare =
    aSquare.id



--  END
