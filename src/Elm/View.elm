module Elm.View exposing (view)

import Array exposing (..)
import Elm.Constants as C
import Elm.Flag exposing (..)
import Elm.Messages exposing (..)
import Elm.Model exposing (Model)
import Elm.SvgExperimentation exposing (svgExperimentation)
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
        ]


viewSpinnerOrPage : Model -> Html Msg
viewSpinnerOrPage model =
    case model.loading of
        True ->
            div [ HtmlAttr.class "blockrow" ] [ Html.text "Loading ..." ]

        False ->
            div []
                [ div [] [ Html.text " " ]
                , div [ HtmlAttr.class "matrix" ] [ insertMatrix model.matrix ]
                , div [ HtmlAttr.class "debug_wrapper" ] [ div [ HtmlAttr.class "debug" ] [ Html.text (viewGameState model.gameState) ] ]
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
    let
        vbWidth =
            C.n_columns * C.squareWidth

        vbHeight =
            C.n_rows * C.squareWidth
    in
    Array.toList matrix
        |> List.map turnColumnIntoHtml
        |> List.concat
        |> List.append insertBackground
        |> svg
            [ viewBox "0 0 1080 480"
            , SvgAttr.class "svg_matrix"
            ]


turnColumnIntoHtml : Array Square -> List (Svg Msg)
turnColumnIntoHtml arrayColumn =
    Array.toList arrayColumn
        |> List.map turnSquareIntoSomeHtmlStuff


turnSquareIntoSomeHtmlStuff : Square -> Html Msg
turnSquareIntoSomeHtmlStuff aSquare =
    let
        x_1 =
            aSquare.i * C.squareWidth

        x_2 =
            x_1 + C.squareWidth

        y_1 =
            aSquare.j * C.squareWidth

        y_2 =
            y_1 + C.squareWidth
    in
    case aSquare.squareViewState of
        SquareViewStateClosed ->
            svgClosedSquare aSquare

        SquareViewStateOpen ->
            svgOpenEmptySquare aSquare

        SquareViewStateFlagged ->
            -- div [ class "square square_flagged", onRightClick (ToggleFlag aSquare) ]
            --     [ img [ class "square_img", src "images/flagged.png" ] []
            --     ]
            rect
                [ x1 (String.fromInt x_1)
                , x2 (String.fromInt x_2)
                , y1 (String.fromInt y_1)
                , y2 (String.fromInt y_2)
                , fill "red"
                ]
                [ img [ HtmlAttr.class "square_img", src "images/flagged.png" ] [] ]


intANDstringTOstring : Int -> String -> String
intANDstringTOstring int string =
    String.fromInt int ++ ", " ++ string


lightGrey =
    "rgb(250,250,250)"


grey =
    "rgb(169,169,169)"


darkGrey =
    "rgb(105,105,105)"


totalWidth =
    "1024"


totalHeight =
    "480"


insertBackground : List (Svg Msg)
insertBackground =
    [ polygon
        [ points "1 1 1024 1 1019 6 6 6"
        , fill lightGrey
        ]
        []
    , polygon
        [ points "1024 1 1024 480 1019 475 1019 6"
        , fill darkGrey
        ]
        []
    , polygon
        [ points "10 10 1014 10 1014 470 10 470 10 10"
        , strokeWidth "10"
        , stroke grey
        , strokeLinecap "square"
        , fill "none"
        ]
        []
    ]


svgClosedSquare : Square -> Svg Msg
svgClosedSquare aSquare =
    svg
        [ SvgAttr.y (String.fromInt (aSquare.i * C.squareWidth))
        , SvgAttr.x (String.fromInt (aSquare.j * C.squareWidth))
        , viewBox ("0 0" ++ String.fromInt C.squareWidth ++ String.fromInt C.squareWidth)
        , fill lightGrey
        , onClick (OpenSquare aSquare)
        , onRightClick (ToggleFlag aSquare)
        ]
        [ polygon [ points "0 0 0 32 32 32 0 0", fill lightGrey ] []
        , polygon [ points "0 32 32 0 32 32 0 32", fill darkGrey ] []
        , rect [ x "4", y "4", SvgAttr.width "24", SvgAttr.height "24", fill grey ] []
        ]


svgOpenEmptySquare : Square -> Svg Msg
svgOpenEmptySquare aSquare =
    openSquareBackground aSquare
        :: insertSquareDrawing aSquare
        |> svg
            [ SvgAttr.y (String.fromInt (aSquare.i * C.squareWidth))
            , SvgAttr.x (String.fromInt (aSquare.j * C.squareWidth))
            , viewBox ("0 0" ++ String.fromInt C.squareWidth ++ String.fromInt C.squareWidth)
            ]


openSquareBackground : Square -> Svg Msg
openSquareBackground aSquare =
    rect
        [ x "0"
        , y "0"
        , SvgAttr.width "32"
        , SvgAttr.height "32"
        , fill grey
        , strokeWidth "1"
        , stroke darkGrey
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

                _ ->
                    svgRedBomb

        BOOOMB ->
            []


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



-- END
