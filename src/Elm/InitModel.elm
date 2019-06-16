module Elm.InitModel exposing (initModel)

import Elm.Constants as C
import Elm.MatrixUtils exposing (generateDefaultMatrix)
import Elm.Model exposing (Model)
import Elm.Types exposing (..)


initModel : Model
initModel =
    { board =
        { n_squares = C.n_squares
        , n_rows = C.n_rows
        , n_columns = C.n_columns
        }
    , bombList = Nothing
    , matrix = generateDefaultMatrix C.n_columns C.n_rows
    , loading = False
    , gameState = NotStarted
    , startingSquare = Nothing
    , n_opened_so_far = 0
    , debug_remaining = []
    }
