module Elm.Svgs exposing (background, redTestSvg, smileyFaceNormal)

import Elm.Constants as C
import Elm.Messages exposing (..)
import Elm.Model exposing (..)
import Html exposing (button)
import Html.Events exposing (onClick)
import String exposing (fromFloat, fromInt)
import Svg exposing (..)
import Svg.Attributes exposing (..)


background : Model -> Svg Msg
background model =
    svg
        [ viewBox "0 0 1020 674"
        , x "0"
        , y "0"
        , width "1020"
        ]
        [ polygon
            [ points "0 0 1020 0 1016 4 4 4 4 631 0 627 0 0"
            , stroke "none"
            , strokeLinecap "square"
            , fill C.lightGrey
            ]
            []
        , polygon
            [ points "1020 0 1020 631 0 631 4 627 1016 627 1016 4 1020 0"
            , stroke "none"
            , fill C.darkGrey
            ]
            []
        , rect [ x "4", y "4", width "1012", height "623", stroke "none", fill C.grey ] []
        , polygon
            [ points "26 90 996 90 992 94 30 94 30 607 26 611 26 90"
            , stroke "none"
            , fill C.darkGrey
            ]
            []
        , polygon
            [ points "26 611 30 607 992 607 992 94 996 90 996 611"
            , stroke "none"
            , fill C.lightGrey
            ]
            []
        , polygon
            [ points "26 22 996 22 992 26 30 26 30 72 26 76 26 22"
            , stroke "none"
            , fill C.darkGrey
            ]
            []
        , polygon
            [ points "26 76 30 72 992 72 992 26 996 22 996 76"
            , stroke "none"
            , fill C.lightGrey
            ]
            []
        , polygon
            [ points "524 29 524 68 563 29"
            , stroke "none"
            , fill C.lightGrey
            ]
            []
        , polygon
            [ points "524 68 563 29 563 68"
            , stroke "none"
            , fill C.darkGrey
            ]
            []
        , rect
            [ x "526"
            , y "31"
            , width "35"
            , height "35"
            , fill C.grey
            ]
            []
        , smileyFaceNormal "522" "27" "42"
        ]


redTestSvg : Svg Msg
redTestSvg =
    let
        a =
            200

        c =
            200

        b =
            a / 2
    in
    svg [ width (fromInt a), height (fromInt c) ]
        [ rect
            [ width "10"
            , height "10"
            , x "10"
            , y "10"
            , fill "red"
            ]
            []
        , rect [ width "10", height "10", x "180", y "180", fill "green" ] []
        , rect [ width "10", height "10", x "180", y "10", fill "blue" ] []
        , rect [ width "10", height "10", x "10", y "180", fill "grey" ] []
        , smileyFaceNormal (fromFloat (a / 2)) "10" "80"
        ]


smileyFaceNormal : String -> String -> String -> Svg Msg
smileyFaceNormal x_ y_ width_ =
        svg
            [ width width_
            , height width_
            , viewBox "0 0 50 50"
            , x x_
            , y y_
            , onClick NewGame
            ]
            [ circle [ cx "25", cy "25", r "16", fill "yellow", strokeWidth "2", stroke "black" ] []
            , line [ x1 "18", y1 "21", x2 "22", y2 "21", strokeWidth "6", stroke "black" ] []
            , line [ x1 "28", y1 "21", x2 "32", y2 "21", strokeWidth "6", stroke "black" ] []
            , line [ x1 "16", y1 "31", x2 "19", y2 "31", strokeWidth "3", stroke "black" ] []
            , line [ x1 "18", y1 "33", x2 "21", y2 "33", strokeWidth "3", stroke "black" ] []
            , line [ x1 "20", y1 "35", x2 "30", y2 "35", strokeWidth "3", stroke "black" ] []
            , line [ x1 "29", y1 "33", x2 "32", y2 "33", strokeWidth "3", stroke "black" ] []
            , line [ x1 "31", y1 "31", x2 "34", y2 "31", strokeWidth "3", stroke "black" ] []
            ]


smileyFaceBox : Svg Msg
smileyFaceBox =
    svg [
    ][]



-- END
