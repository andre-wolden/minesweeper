module Elm.View exposing (view)

import Array exposing (..)
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
        , div [ class "board" ] [ text "List of Random Numbers:" ]
        , viewListOfRandomNumbers model
        ]


viewListOfRandomNumbers : Model -> Html Msg
viewListOfRandomNumbers model =
    case model.bombList of
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
