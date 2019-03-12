module Elm.Update exposing (update)

import Array exposing (..)
import Elm.Constants as C
import Elm.GenerateMatrixWithBombs exposing (..)
import Elm.MatrixAddBombNeighbouringNumber exposing (updateMatrixWithBombNeighbouringNumbers)
import Elm.MatrixUtils exposing (..)
import Elm.Messages exposing (Msg(..))
import Elm.Model exposing (Model)
import Elm.RandomNumber exposing (..)
import Elm.RecursiveOpening exposing (doTheTrickyPart)
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
                            { model | startingSquare = Just squareToOpen, n_opened_so_far = 1 }
                    in
                    update GenerateListOfRandomNumbersForNBombs updated_model

                InGame ->
                    let
                        n_opened_so_far_updated =
                            model.n_opened_so_far + 1

                        updated_matrix =
                            openSquare model.matrix squareToOpen

                        isVictorious =
                            checkIfVictorious n_opened_so_far_updated
                    in
                    case squareToOpen.square_content of
                        JustAnEmptySquare ->
                            doTheTrickyPart model squareToOpen updated_matrix n_opened_so_far_updated isVictorious

                        ANumber n_nabo_miner ->
                            ( { model
                                | matrix = updated_matrix
                                , n_opened_so_far = n_opened_so_far_updated
                                , gameState =
                                    if isVictorious then
                                        Victorious

                                    else
                                        InGame
                              }
                            , Cmd.none
                            )

                        BOOOMB ->
                            ( { model
                                | matrix = updated_matrix
                                , gameState = Dead
                                , n_opened_so_far = n_opened_so_far_updated
                              }
                            , Cmd.none
                            )

                Dead ->
                    ( model, Cmd.none )

                Victorious ->
                    ( model, Cmd.none )



-- END
