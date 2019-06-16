port module Main exposing (init, main, toJs)

import Array exposing (..)
import Browser
import Browser.Navigation as Nav
import Elm.Constants as C
import Elm.InitModel exposing (initModel)
import Elm.MatrixUtils exposing (generateDefaultMatrix)
import Elm.Messages exposing (Msg(..))
import Elm.Model exposing (Model)
import Elm.Types exposing (GameState(..))
import Elm.Update exposing (update)
import Elm.View exposing (view)


port toJs : String -> Cmd msg


main : Program Int Model Msg
main =
    Browser.document
        { init = init
        , update = update
        , view =
            \m ->
                { title = "Elm 0.19 starter"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        }


init : Int -> ( Model, Cmd Msg )
init flags =
    ( initModel, Cmd.none )



-- END
