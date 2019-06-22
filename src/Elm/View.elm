module Elm.View exposing (view)

import Array exposing (..)
import Elm.Constants as C
import Elm.Flag exposing (..)
import Elm.Messages exposing (..)
import Elm.Model exposing (Model)
import Elm.Svgs as S
import Elm.Types exposing (..)
import Html exposing (..)
import Html.Attributes as HtmlAttr exposing (..)
import Html.Events exposing (..)
import Svg exposing (..)
import Svg.Attributes as SvgAttr exposing (..)


view : Model -> Html Msg
view model =
    div [ HtmlAttr.class "container" ]
        [ viewSpinnerOrPage model
        , div [ HtmlAttr.class "debug_wrapper" ] [ div [ HtmlAttr.class "debug" ] [ Html.text (viewGameState model.gameState) ] ]
        ]


viewSpinnerOrPage : Model -> Html Msg
viewSpinnerOrPage model =
    case model.loading of
        True ->
            div [ HtmlAttr.class "blockrow" ] [ Html.text "Loading ..." ]

        False ->
            div [ HtmlAttr.class "wrapper" ]
                [ div [ HtmlAttr.class "matrix" ] [ insertMatrix model.matrix ]
                , div [ HtmlAttr.class "svg_background" ] [ S.background model ]
                , div [ HtmlAttr.class "smiley_button" ] [ button [] [ Html.text "O" ] ]
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


insertMatrix : Matrix -> Html Msg
insertMatrix matrix =
    Array.toList matrix
        |> List.map turnColumnIntoHtml
        |> List.concat
        |> svg
            [ viewBox "0 0 1080 680"
            , SvgAttr.class "svg_matrix"
            ]


turnColumnIntoHtml : Array Square -> List (Svg Msg)
turnColumnIntoHtml arrayColumn =
    Array.toList arrayColumn
        |> List.map turnSquareIntoSomeHtmlStuff


turnSquareIntoSomeHtmlStuff : Square -> Html Msg
turnSquareIntoSomeHtmlStuff aSquare =
    case aSquare.squareViewState of
        SquareViewStateClosed ->
            svgClosedSquare aSquare

        SquareViewStateOpen ->
            svgOpenEmptySquare aSquare

        SquareViewStateFlagged ->
            svgFlag
                |> List.append svgClosedSquareBackground
                |> svg (svgClosedSquareBaseAttributes aSquare)


svgClosedSquareBaseAttributes : Square -> List (Html.Attribute Msg)
svgClosedSquareBaseAttributes aSquare =
    [ SvgAttr.y (String.fromInt ((aSquare.i * C.squareWidth) + 64))
    , SvgAttr.x (String.fromInt (aSquare.j * C.squareWidth))
    , fill C.lightGrey
    , onRightClick (ToggleFlag aSquare)
    ]


svgClosedSquareBackground : List (Svg Msg)
svgClosedSquareBackground =
    [ polygon [ points "0 0 0 32 32 0 0 0", fill C.lightGrey ] []
    , polygon [ points "0 32 32 0 32 32 0 32", fill C.darkGrey ] []
    , rect [ x "4", y "4", SvgAttr.width "24", SvgAttr.height "24", fill C.grey ] []
    ]


svgClosedSquare : Square -> Svg Msg
svgClosedSquare aSquare =
    svg
        [ SvgAttr.y (String.fromInt ((aSquare.i * C.squareWidth) + 64))
        , SvgAttr.x (String.fromInt (aSquare.j * C.squareWidth))
        , fill C.lightGrey
        , onClick (OpenSquare aSquare)
        , onRightClick (ToggleFlag aSquare)
        ]
        [ polygon [ points "0 0 0 32 32 0 0 0", fill C.lightGrey ] []
        , polygon [ points "0 32 32 0 32 32 0 32", fill C.darkGrey ] []
        , rect [ x "4", y "4", SvgAttr.width "24", SvgAttr.height "24", fill C.grey ] []
        ]


svgOpenEmptySquare : Square -> Svg Msg
svgOpenEmptySquare aSquare =
    openSquareBackground aSquare
        :: insertSquareDrawing aSquare
        |> svg
            [ SvgAttr.y (String.fromInt ((aSquare.i * C.squareWidth) + 64))
            , SvgAttr.x (String.fromInt (aSquare.j * C.squareWidth))
            ]


openSquareBackground : Square -> Svg Msg
openSquareBackground aSquare =
    rect
        [ x "0"
        , y "0"
        , SvgAttr.width "32"
        , SvgAttr.height "32"
        , fill C.grey
        , strokeWidth "1"
        , stroke C.darkGrey
        ]
        []


insertSquareDrawing : Square -> List (Svg Msg)
insertSquareDrawing aSquare =
    case aSquare.square_content of
        JustAnEmptySquare ->
            []

        ANumber int ->
            case aSquare.n_nabo_miner of
                1 ->
                    svgOne

                2 ->
                    svgTwo

                3 ->
                    svgThree

                4 ->
                    svgFour

                5 ->
                    svgFive

                _ ->
                    svgOtherNumber

        BOOOMB ->
            svgRedBomb


svgRedBomb : List (Svg Msg)
svgRedBomb =
    [ rect [ x "0", y "0", SvgAttr.width "32", SvgAttr.height "32", SvgAttr.stroke "none", SvgAttr.fill "red" ] []
    , rect [ x "8", y "8", SvgAttr.width "16", SvgAttr.height "16", SvgAttr.stroke "none", SvgAttr.fill "black" ] []
    , rect [ x "6", y "11", SvgAttr.width "20", SvgAttr.height "10", SvgAttr.stroke "none", SvgAttr.fill "black" ] []
    , rect [ x "11", y "6", SvgAttr.width "10", SvgAttr.height "20", SvgAttr.stroke "none", SvgAttr.fill "black" ] []
    , line [ x1 "16", y1 "2", x2 "16", y2 "30", stroke "black", strokeWidth "2" ] []
    , line [ x1 "2", y1 "16", x2 "30", y2 "16", stroke "black", strokeWidth "2" ] []
    , line [ x1 "7", y1 "25", x2 "25", y2 "7", stroke "black", strokeWidth "1" ] []
    , line [ x1 "7", y1 "7", x2 "25", y2 "25", stroke "black", strokeWidth "2" ] []
    , rect [ x "11", y "11", SvgAttr.width "3", SvgAttr.height "3", SvgAttr.stroke "none", SvgAttr.fill "white" ] []
    ]


svgFlag : List (Svg Msg)
svgFlag =
    [ line [ x1 "10", y1 "12", x2 "15", y2 "12", stroke "red", strokeWidth "4" ] []
    , line [ x1 "15", y1 "8", x2 "15", y2 "15", stroke "red", strokeWidth "5" ] []
    , line [ x1 "19", y1 "6", x2 "19", y2 "17", stroke "red", strokeWidth "5" ] []
    , line [ x1 "20", y1 "17", x2 "20", y2 "24", stroke "black", strokeWidth "2" ] []
    , line [ x1 "11", y1 "22", x2 "24", y2 "22", stroke "black", strokeWidth "2" ] []
    , line [ x1 "9", y1 "24", x2 "25", y2 "24", stroke "black", strokeWidth "4" ] []
    ]


svgOne : List (Svg Msg)
svgOne =
    [ line [ x1 "8", y1 "26", x2 "24", y2 "26", stroke "blue", strokeWidth "4" ] []
    , line [ x1 "18", y1 "24", x2 "18", y2 "5", stroke "blue", strokeWidth "4" ] []
    , line [ x1 "15", y1 "25", x2 "15", y2 "7", stroke "blue", strokeWidth "4" ] []
    , line [ x1 "12", y1 "14", x2 "12", y2 "9", stroke "blue", strokeWidth "4" ] []
    , line [ x1 "10", y1 "14", x2 "10", y2 "11", stroke "blue", strokeWidth "4" ] []
    ]


svgTwo : List (Svg Msg)
svgTwo =
    [ line [ x1 "6", y1 "25", x2 "26", y2 "25", stroke "green", strokeWidth "4" ] []
    , line [ x1 "8", y1 "22", x2 "14", y2 "22", stroke "green", strokeWidth "4" ] []
    , line [ x1 "12", y1 "19", x2 "18", y2 "19", stroke "green", strokeWidth "4" ] []
    , line [ x1 "17", y1 "16", x2 "23", y2 "16", stroke "green", strokeWidth "4" ] []
    , line [ x1 "23", y1 "16", x2 "23", y2 "8", stroke "green", strokeWidth "4" ] []
    , line [ x1 "9", y1 "8", x2 "23", y2 "8", stroke "green", strokeWidth "4" ] []
    , line [ x1 "6", y1 "11", x2 "11", y2 "11", stroke "green", strokeWidth "4" ] []
    ]


svgThree : List (Svg Msg)
svgThree =
    [ line [ x1 "7", y1 "7", x2 "24", y2 "7", stroke "red", strokeWidth "4" ] []
    , line [ x1 "23", y1 "6", x2 "23", y2 "15", stroke "red", strokeWidth "5" ] []
    , line [ x1 "13", y1 "16", x2 "25", y2 "16", stroke "red", strokeWidth "4" ] []
    , line [ x1 "23", y1 "17", x2 "23", y2 "26", stroke "red", strokeWidth "5" ] []
    , line [ x1 "7", y1 "25", x2 "24", y2 "25", stroke "red", strokeWidth "4" ] []
    ]


svgFour : List (Svg Msg)
svgFour =
    [ line [ x1 "9", y1 "6", x2 "13", y2 "6", stroke "purple", strokeWidth "4" ] []
    , line [ x1 "8", y1 "10", x2 "12", y2 "10", stroke "purple", strokeWidth "4" ] []
    , line [ x1 "6", y1 "14", x2 "23", y2 "14", stroke "purple", strokeWidth "4" ] []
    , line [ x1 "19", y1 "4", x2 "19", y2 "26", stroke "purple", strokeWidth "5" ] []
    ]


svgFive : List (Svg Msg)
svgFive =
    [ line [ x1 "6", y1 "7", x2 "22", y2 "7", stroke "brown", strokeWidth "4" ] []
    , line [ x1 "9", y1 "9", x2 "9", y2 "16", stroke "brown", strokeWidth "5" ] []
    , line [ x1 "6", y1 "17", x2 "20", y2 "17", stroke "brown", strokeWidth "4" ] []
    , line [ x1 "21", y1 "16", x2 "21", y2 "25", stroke "brown", strokeWidth "5" ] []
    , line [ x1 "21", y1 "25", x2 "6", y2 "25", stroke "brown", strokeWidth "4" ] []
    ]


svgOtherNumber : List (Svg Msg)
svgOtherNumber =
    [ line [ x1 "23", y1 "17", x2 "23", y2 "26", stroke "red", strokeWidth "5" ] []
    , line [ x1 "7", y1 "25", x2 "24", y2 "25", stroke "red", strokeWidth "4" ] []
    ]



-- END
