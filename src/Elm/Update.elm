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



-- { model
--     | matrix = updated_matrix
--     , n_opened_so_far = n_opened_so_far_updated
--     , gameState =
--         if isVictorious then
--             Victorious
--
--         else
--             InGame
-- }


doTheTrickyPart : Model -> Square -> Matrix -> Int -> Bool -> ( Model, Cmd Msg )
doTheTrickyPart model squareToOpen updated_matrix n_opened_so_far_updated isVictorious =
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



--     let
--         neighbours =
--             getAllNeighbours updated_matrix squareToOpen.i squareToOpen.j
--     in
--     Array.toList neighbours
--         |> List.filterMap keepSquareIfJustSquare
--         |> List.map
--             (\aSquareToOpen ->
--                 update (OpenSquare aSquareToOpen)
--                     { model
--                         | matrix = updated_matrix
--                         , n_opened_so_far = n_opened_so_far_updated
--                         , gameState =
--                             if isVictorious then
--                                 Victorious
--
--                             else
--                                 InGame
--                     }
--             )
--         |> List.reverse
--         |> List.head
--         |> andThenCaseTheAnswer model
--
--
-- andThenCaseTheAnswer : Model -> Maybe ( Model, Cmd Msg ) -> ( Model, Cmd Msg )
-- andThenCaseTheAnswer oldModel msgCmdModelMaybe =
--     case msgCmdModelMaybe of
--         Just ( model, msgCmd ) ->
--             ( model, msgCmd )
--
--         Nothing ->
--             ( oldModel, Cmd.none )


keepSquareIfJustSquare : Maybe Square -> Maybe Square
keepSquareIfJustSquare maybeSquare =
    case maybeSquare of
        Just aSquare ->
            Just aSquare

        Nothing ->
            Nothing


checkIfVictorious : Int -> Bool
checkIfVictorious n_opened_so_far_updated =
    if n_opened_so_far_updated == (C.n_squares - C.n_bombs) then
        True

    else
        False


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
                    getAllNine model.matrix justStartingSquare.i justStartingSquare.j
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
