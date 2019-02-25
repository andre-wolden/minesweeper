module Elm.Messages exposing (Msg(..))


type Msg
    = NoOp
    | GenerateRandomNumber
    | GotRandomNumber Int
    | AddRandomNumberToListOfRandomNumbers
    | NowGenerateAllTheSquares
