module Elm.Messages exposing (Msg(..))

import Elm.Types exposing (Square)


type Msg
    = NoOp
    | GenerateListOfRandomNumbersForNBombs
    | GotBombList (List Int)
    | OpenSquare Square
    | ToggleFlag Square



-- | NowGenerateAllTheSquares
-- | NowAssignNumberOfNeighbouringBombs
