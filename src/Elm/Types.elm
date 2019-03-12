module Elm.Types exposing (AlgDat, Board, GameState(..), GameStatus, Matrix, Square, SquareContent(..), SquareViewState(..))

import Array exposing (..)


type alias Board =
    { n_squares : Int
    , n_columns : Int
    , n_rows : Int
    }


type alias Square =
    { id : Int
    , i : Int -- Column
    , j : Int -- Row
    , square_content : SquareContent
    , n_nabo_miner : Int
    , squareViewState : SquareViewState
    }


type SquareViewState
    = SquareViewStateClosed
    | SquareViewStateOpen
    | SquareViewStateFlagged


type GameStatus
    = ReadyToStart
    | Ongoing
    | Won
    | Lost


type SquareContent
    = JustAnEmptySquare
    | ANumber Int
    | BOOOMB


type alias Matrix =
    Array (Array Square)


type GameState
    = NotStarted
    | InGame
    | Dead
    | Victorious


type alias AlgDat =
    { remaining : List Square
    , current_matrix : Matrix
    , current_square : Square
    , done : List Square
    , debug_remaining : List Square
    }



-- END
