module Elm.Flag exposing (onRightClick)

import Elm.Messages exposing (..)
import Elm.Model exposing (Model)
import Elm.Types exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode


onRightClick : msg -> Attribute msg
onRightClick message =
    on "contextmenu" (Decode.succeed message)
