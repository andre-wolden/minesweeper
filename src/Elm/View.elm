module Elm.View exposing (view)

import Array exposing (..)
import Elm.Flag exposing (..)
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
        , viewSpinnerOrPage model
        ]


viewSpinnerOrPage : Model -> Html Msg
viewSpinnerOrPage model =
    case model.loading of
        True ->
            div [ class "blockrow" ] [ text "Loading ..." ]

        False ->
            div [ class "blockrow" ]
                [ div [ class "blockrow" ] [ text "------" ]
                , div [ class "blockrow" ] [ text "List of Random Numbers:" ]
                , div [ class "blockrow" ] [ viewListOfRandomNumbers model ]
                , div [ class "blockrow" ] [ div [ class "board" ] (insertMatrix model.matrix) ]
                , div [ class "blockrow" ] [ text (viewGameState model.gameState) ]
                , div [ class "blockrow" ] []
                ]


viewGameState : GameState -> String
viewGameState gameState =
    case gameState of
        NotStarted ->
            "Not Started"

        InGame ->
            "In Game"

        Dead ->
            "BOOOOM!"

        Victorious ->
            "Victory !"


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
    case aSquare.squareViewState of
        SquareViewStateClosed ->
            div [ class "square_closed", onClick (OpenSquare aSquare), onRightClick (ToggleFlag aSquare) ] []

        SquareViewStateOpen ->
            let
                string_content =
                    stringContentOfSquare aSquare
            in
            div [ class "square_open" ] [ text string_content ]

        SquareViewStateFlagged ->
            div [ class "square_flagged", onRightClick (ToggleFlag aSquare) ] []


stringContentOfSquare : Square -> String
stringContentOfSquare aSquare =
    case aSquare.square_content of
        JustAnEmptySquare ->
            ""

        ANumber int ->
            String.fromInt int

        BOOOMB ->
            "X"


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
