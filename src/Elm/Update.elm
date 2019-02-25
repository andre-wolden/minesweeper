module Elm.Update exposing (update)

import Elm.Messages exposing (Msg(..))
import Elm.Model exposing (Model)
import Elm.RandomNumber exposing (..)
import Random


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )

        GenerateRandomNumber ->
            ( model, Random.generate GotRandomNumber randomNumber )

        GotRandomNumber int ->
            ( { model | random_number = Just int }, Cmd.none )
