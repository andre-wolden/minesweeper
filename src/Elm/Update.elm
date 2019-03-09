module Elm.Update exposing (update)

import Array exposing (..)
import Elm.Constants as C
import Elm.GenerateMatrixWithBombs exposing (..)
import Elm.MatrixAddBombNeighbouringNumber exposing (updateMatrixWithBombNeighbouringNumbers)
import Elm.MatrixUtils exposing (..)
import Elm.Messages exposing (Msg(..))
import Elm.Model exposing (Model)
import Elm.RandomNumber exposing (..)
import Elm.Types exposing (GameState(..), Matrix, Square, SquareContent(..), SquareViewState(..))
import Random


update : Msg -> Model -> ( Model, Cmd Msg )
update message model =
    case message of
        NoOp ->
            ( model, Cmd.none )

        GenerateListOfRandomNumbersForNBombs ->
            let
                startingSquare =
                    model.startingSquare

                listOfNumbersToRemove =
                    generateListOfNumbersToRemove model
            in
            ( model, Random.generate GotBombList (randomListOfIntAfterInitialClick listOfNumbersToRemove) )

        GotBombList bombList ->
            case model.startingSquare of
                Just shouldBeAStartingSquareAlways ->
                    let
                        sorted_bomb_list : Maybe (List Int)
                        sorted_bomb_list =
                            Just (List.sort bombList)

                        matrix_with_bombs : Matrix
                        matrix_with_bombs =
                            generateMatrixWithBombs bombList C.n_columns C.n_rows

                        matrix_with_neighbour_number : Matrix
                        matrix_with_neighbour_number =
                            updateMatrixWithBombNeighbouringNumbers matrix_with_bombs

                        startingMatrixWithOneOpenSquare =
                            openSquare matrix_with_neighbour_number shouldBeAStartingSquareAlways
                    in
                    ( { model
                        | matrix = startingMatrixWithOneOpenSquare
                        , bombList = Just bombList
                        , gameState = InGame
                      }
                    , Cmd.none
                    )

                Nothing ->
                    ( model, Cmd.none )

        OpenSquare squareToOpen ->
            case model.gameState of
                NotStarted ->
                    let
                        updated_model =
                            { model | startingSquare = Just squareToOpen }
                    in
                    update GenerateListOfRandomNumbersForNBombs updated_model

                InGame ->
                    let
                        updated_matrix =
                            openSquare model.matrix squareToOpen
                    in
                    ( { model | matrix = updated_matrix }, Cmd.none )


openSquare : Matrix -> Square -> Matrix
openSquare matrix squareToOpen =
    let
        squareToOpen_updated =
            { squareToOpen | squareViewState = SquareViewStateOpen }

        maybeColumnToUpdate =
            Array.get (squareToOpen.i - 1) matrix

        arrayToBeUpdated_updated =
            updateArrayWithUpdatedSquare maybeColumnToUpdate squareToOpen_updated
    in
    Array.set (squareToOpen_updated.i - 1) arrayToBeUpdated_updated matrix


updateArrayWithUpdatedSquare : Maybe (Array Square) -> Square -> Array Square
updateArrayWithUpdatedSquare maybeSquareArray updated_square =
    case maybeSquareArray of
        Just arrayToBeUpdated ->
            Array.set (updated_square.j - 1) updated_square arrayToBeUpdated

        Nothing ->
            Array.empty


generateListOfNumbersToRemove : Model -> List Int
generateListOfNumbersToRemove model =
    case model.startingSquare of
        Just justStartingSquare ->
            let
                arrayOfMaybeSquare =
                    getNeighbours model.matrix justStartingSquare.i justStartingSquare.j
            in
            List.filterMap squareToMaybeInt (toList arrayOfMaybeSquare)

        Nothing ->
            []


squareToMaybeInt : Maybe Square -> Maybe Int
squareToMaybeInt maybeSquare =
    case maybeSquare of
        Just aSquare ->
            Just aSquare.id

        Nothing ->
            Nothing



-- END
