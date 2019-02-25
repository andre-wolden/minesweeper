port module Main exposing (init, main, toJs)

import Browser
import Browser.Navigation as Nav
import Elm.Constants as Constants
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
                { title = "Elm 0.19 starter"
                , body = [ view m ]
                }
        , subscriptions = \_ -> Sub.none
        }


init : Int -> ( Model, Cmd Msg )
init flags =
    update GenerateRandomNumber initModel


initModel : Model
initModel =
    { random_number = Nothing
    , list_of_random_numbers = Nothing
    , board =
        { n_squares = Constants.n_squares
        , n_rows = Constants.n_rows
        , n_columns = Constants.n_columns
        }
    , squares = []
    }



-- END
