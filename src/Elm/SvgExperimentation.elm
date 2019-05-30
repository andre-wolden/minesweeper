module Elm.SvgExperimentation exposing (svgExperimentation)

import Elm.Messages exposing (..)
import Html exposing (..)
import Svg exposing (..)
import Svg.Attributes as SvgAttr exposing (..)


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


svgExperimentation : Html Msg
svgExperimentation =
    div []
        [ svg
            [ SvgAttr.class "svg_experiment"
            , viewBox ("0 0" ++ totalWidth ++ totalHeight)
            ]
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
        ]



-- END
