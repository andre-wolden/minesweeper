module Elm.View exposing (view)

import Elm.Messages exposing (..)
import Elm.Model exposing (Model)
import Elm.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ text "My life, for Aiur"
        , div [] [ text "------" ]
        , div [] [ text "Random number:" ]
        , viewRandomNumber model.random_number
        , div [] [ text "------" ]
        , div [] [ text "List of Random Numbers:" ]
        , viewListOfRandomNumbers model
        , insertBoard model
        ]



-- VIEW SQUARE WITH INFO IN


insertBoard : Model -> Html Msg
insertBoard model =
    div [ class "board" ] (List.map insertSquare model.squares)


insertSquare : Square -> Html Msg
insertSquare square =
    div [ class "square" ] [ text "square" ]



-- RANDOM STUFF


viewRandomNumber : Maybe Int -> Html Msg
viewRandomNumber maybeRandomNumber =
    case maybeRandomNumber of
        Just int ->
            String.fromInt int
                |> text

        Nothing ->
            text "Nothing yet"


viewListOfRandomNumbers : Model -> Html Msg
viewListOfRandomNumbers model =
    case model.list_of_random_numbers of
        Just intList ->
            List.foldl intANDstringTOstring baseString intList
                |> text

        Nothing ->
            span [] [ text "no list yet" ]


intANDstringTOstring : Int -> String -> String
intANDstringTOstring int string =
    String.fromInt int ++ baseString ++ string


baseString : String
baseString =
    ", "
