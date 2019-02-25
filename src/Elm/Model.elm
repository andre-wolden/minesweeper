module Elm.Model exposing (Model)

import Elm.Types exposing (Board, Square)


type alias Model =
    { random_number : Maybe Int
    , list_of_random_numbers : Maybe (List Int)
    , board : Board
    , squares : List Square
    }
