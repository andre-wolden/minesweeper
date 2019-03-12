module Elm.Model exposing (Model)

import Array exposing (Array)
import Elm.Types exposing (..)


type alias Model =
    { board : Board
    , bombList : Maybe (List Int)
    , matrix : Matrix
    , loading : Bool
    , gameState : GameState
    , startingSquare : Maybe Square
    , n_opened_so_far : Int
    , debug_remaining : List Square
    }
