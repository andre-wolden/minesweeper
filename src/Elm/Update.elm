module Elm.Update exposing (update)

import Array exposing (..)
import Elm.Constants as C
import Elm.GenerateMatrixWithBombs exposing (..)
import Elm.InitModel exposing (initModel)
import Elm.MatrixAddBombNeighbouringNumber exposing (updateMatrixWithBombNeighbouringNumbers)
import Elm.MatrixUtils as MatrixUtils exposing (..)
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

                random_list =
                    randomListOfIntAfterInitialClick listOfNumbersToRemove
            in
            ( model, Random.generate GotBombList random_list )

        GotBombList bombList ->
            case model.startingSquare of
                Just shouldBeAStartingSquareAlways ->
                    let
                        sorted_bomb_list : Maybe (List Int)
                        sorted_bomb_list =
                            Just (List.sort bombList)

                        -- _ =
                        --     Debug.log "Random list: " sorted_bomb_list
                        matrix_with_bombs : Matrix
                        matrix_with_bombs =
                            generateMatrixWithBombs bombList C.n_columns C.n_rows

                        matrix_with_neighbour_number : Matrix
                        matrix_with_neighbour_number =
                            updateMatrixWithBombNeighbouringNumbers matrix_with_bombs

                        startingMatrixWithOneOpenSquare =
                            openSquare matrix_with_neighbour_number shouldBeAStartingSquareAlways

                        isVictorious : Bool
                        isVictorious =
                            seeIfVictorious startingMatrixWithOneOpenSquare
                    in
                    doTheTrickyPart model shouldBeAStartingSquareAlways startingMatrixWithOneOpenSquare 1 isVictorious

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
                            seeIfVictorious updated_matrix
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
                            let
                                updated_matrix_with_all_bomb_squares_opened =
                                    MatrixUtils.openAllBombSquares updated_matrix
                            in
                            ( { model
                                | matrix = updated_matrix_with_all_bomb_squares_opened
                                , gameState = Dead
                                , n_opened_so_far = n_opened_so_far_updated
                              }
                            , Cmd.none
                            )

                Dead ->
                    ( model, Cmd.none )

                Victorious ->
                    ( model, Cmd.none )

        ToggleFlag aSquare ->
            let
                --_ =
                --    Debug.log "Toggle Flag ass" 13

                matrix_updated =
                    toggleFlagOnSquare model.matrix aSquare
            in
            ( { model | matrix = matrix_updated }, Cmd.none )

        NewGame ->
            --let
            --    --_ =
            --    --    Debug.log "Start new game..." 13
            --in
            ( initModel, Cmd.none )


seeIfVictorious : Matrix -> Bool
seeIfVictorious matrix =
    Array.map noRemainingClosedSquaresInArray matrix
        |> Array.toList
        |> List.member False
        |> not


noRemainingClosedSquaresInArray : Array Square -> Bool
noRemainingClosedSquaresInArray squareArray =
    Array.map squareIsOpenOrBombSquare squareArray
        |> Array.toList
        |> List.member False
        |> not


squareIsOpenOrBombSquare : Square -> Bool
squareIsOpenOrBombSquare aSquare =
    case aSquare.square_content of
        BOOOMB ->
            True

        _ ->
            case aSquare.squareViewState of
                SquareViewStateOpen ->
                    True

                _ ->
                    False



-- END
