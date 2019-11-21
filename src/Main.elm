port module Main exposing (init, main, toJs)

import Browser
import Elm.InitModel exposing (initModel)
import Elm.Messages exposing (Msg(..))
import Elm.Model exposing (Model)
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
                { title = "Wolden's Minesweeper Copy"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        }


init : Int -> ( Model, Cmd Msg )
init flags =
    ( initModel, Cmd.none )



-- END
