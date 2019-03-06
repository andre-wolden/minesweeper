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
        , div [ class "board" ] (insertMatrix model.matrix)
        ]


insertMatrix : Matrix -> List (Html Msg)
insertMatrix matrix =
    Array.toList matrix
        |> List.map turnColumnIntoHtml


turnColumnIntoHtml : Array Square -> Html Msg
turnColumnIntoHtml arrayColumn =
    Array.toList arrayColumn
        |> List.map turnSquareIntoSomeHtmlStuff
        |> div [ class "column" ]


turnSquareIntoSomeHtmlStuff : Square -> Html Msg
turnSquareIntoSomeHtmlStuff aSquare =
    case aSquare.square_content of
        JustAnEmptySquare ->
            div [ class "square" ] [ text (String.fromInt aSquare.n_nabo_miner) ]

        ANumber int ->
            div [ class "square" ] [ text (String.fromInt aSquare.n_nabo_miner) ]

        BOOOMB ->
            div [ class "square" ] [ img [ src "images/red_bomb.png", class "bombimage" ] [] ]


viewListOfRandomNumbers : Model -> Html Msg
viewListOfRandomNumbers model =
    case model.bombList of
        Just intList ->
            List.foldl intANDstringTOstring "" intList
                |> text

        Nothing ->
            span [] [ text "no list yet" ]


intANDstringTOstring : Int -> String -> String
intANDstringTOstring int string =
    String.fromInt int ++ ", " ++ string
