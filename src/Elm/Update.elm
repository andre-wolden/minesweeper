module Elm.Update exposing (update)

import Elm.Constants exposing (n_bombs)
import Elm.Messages exposing (Msg(..))
import Elm.Model exposing (Model)
import Elm.RandomNumber exposing (..)
import Elm.Types exposing (Square, SquareContent(..))
import Random


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )

        GenerateRandomNumber ->
            ( model, Random.generate GotRandomNumber randomNumber )

        GotRandomNumber int ->
            update AddRandomNumberToListOfRandomNumbers { model | random_number = Just int }

        AddRandomNumberToListOfRandomNumbers ->
            case model.random_number of
                Just randomNumber ->
                    case model.list_of_random_numbers of
                        Just intList ->
                            update (doThisAgainIfListAintFullAlready intList) { model | list_of_random_numbers = Just ((::) randomNumber intList) }

                        Nothing ->
                            update GenerateRandomNumber { model | list_of_random_numbers = Just [ randomNumber ] }

                Nothing ->
                    ( model, Cmd.none )

        NowGenerateAllTheSquares ->
            case model.list_of_random_numbers of
                Just intList ->
                    ( { model | squares = generateAllTheSquares intList }, Cmd.none )

                Nothing ->
                    ( model, Cmd.none )



-- GENERATING SQUARES STUFF


generateAllTheSquares : List Int -> List Square
generateAllTheSquares list_of_random_numbers =
    [ { id = 1
      , i = 1 -- Column
      , j = 1 -- Row
      , square_content = JustAnEmptySquare
      }
    , { id = 2
      , i = 2 -- Column
      , j = 1 -- Row
      , square_content = ANumber 1
      }
    , { id = 3
      , i = 3 -- Column
      , j = 1 -- Row
      , square_content = BOOOMB
      }

    -- Second Row
    , { id = 4
      , i = 1 -- Column
      , j = 2 -- Row
      , square_content = JustAnEmptySquare
      }
    , { id = 5
      , i = 2 -- Column
      , j = 2 -- Row
      , square_content = ANumber 2
      }
    , { id = 6
      , i = 3 -- Column
      , j = 2 -- Row
      , square_content = BOOOMB
      }

    -- Row 3
    , { id = 7
      , i = 1 -- Column
      , j = 3 -- Row
      , square_content = JustAnEmptySquare
      }
    , { id = 8
      , i = 2 -- Column
      , j = 3 -- Row
      , square_content = ANumber 3
      }
    , { id = 9
      , i = 3 -- Column
      , j = 3 -- Row
      , square_content = BOOOMB
      }
    ]



-- RANDOM NUMBER GENERATION STUFF


doThisAgainIfListAintFullAlready : List Int -> Msg
doThisAgainIfListAintFullAlready intList =
    if List.length intList < n_bombs then
        GenerateRandomNumber

    else
        NowGenerateAllTheSquares
