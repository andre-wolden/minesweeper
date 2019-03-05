module Elm.Messages exposing (Msg(..))


type Msg
    = NoOp
    | GenerateListOfRandomNumbersForNBombs
    | GotBombList (List Int)
    | NowGenerateAllTheSquares
