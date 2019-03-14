module Elm.MatrixUtils exposing
    ( Dota
    , addIJIDtoMatrix
    , baseSquare
    , calculateSquareId
    , checkIfVictorious
    , generateDefaultMatrix
    , generateListOfNumbersToRemove
    , generateMatrixAndPopulateWithBaseSquare
    , getAllNeighbours
    , getAllNine
    , getListOfEmptyButStillClosedNeighbours
    , getListOfEmptyNeighbours
    , openAllNeighbours
    , openNeighboursRecursively
    , openSquare
    , squareToMaybeInt
    , toSquare
    , toggleFlagOnSquare
    , updateArrayWithUpdatedSquare
    , updateColumn
    , updateSquareInRow
    )

import Array exposing (..)
import Elm.Constants as C
import Elm.MatrixAddBombNeighbouringNumber exposing (maybeGetASquareAt)
import Elm.Model exposing (..)
import Elm.Types exposing (Matrix, Square, SquareContent(..), SquareViewState(..))


type alias Dota =
    { closedNeighbours : List Square
    , matrix : Matrix
    }


openAllNeighbours : Matrix -> Square -> Matrix
openAllNeighbours matrix aSquare =
    let
        closedNeighbours =
            getAllClosedNeighbours matrix aSquare.i aSquare.j

        init_dota =
            { closedNeighbours = closedNeighbours, matrix = matrix }

        final_dota =
            openNeighboursRecursively init_dota
    in
    final_dota.matrix


openNeighboursRecursively : Dota -> Dota
openNeighboursRecursively dota =
    let
        next_to_open =
            List.head dota.closedNeighbours

        matrix_updated =
            case next_to_open of
                Just the_next_one_to_open ->
                    openSquare dota.matrix the_next_one_to_open

                Nothing ->
                    dota.matrix

        closedNeighbours_updated =
            List.tail dota.closedNeighbours
    in
    case closedNeighbours_updated of
        Just [] ->
            { closedNeighbours = [], matrix = matrix_updated }

        Just aListWithContent ->
            openNeighboursRecursively { closedNeighbours = aListWithContent, matrix = matrix_updated }

        Nothing ->
            { closedNeighbours = [], matrix = matrix_updated }



-- 1, 2, 3
-- 4,  , 6
-- 7, 8, 9


getAllNeighbours : Matrix -> Int -> Int -> List Square
getAllNeighbours matrix i j =
    let
        up_left : Maybe Square
        up_left =
            maybeGetASquareAt (i - 1) (j - 1) matrix

        up_up : Maybe Square
        up_up =
            maybeGetASquareAt i (j - 1) matrix

        up_right : Maybe Square
        up_right =
            maybeGetASquareAt (i + 1) (j - 1) matrix

        left_left : Maybe Square
        left_left =
            maybeGetASquareAt (i - 1) j matrix

        right_right : Maybe Square
        right_right =
            maybeGetASquareAt (i + 1) j matrix

        down_left : Maybe Square
        down_left =
            maybeGetASquareAt (i - 1) (j + 1) matrix

        down_down : Maybe Square
        down_down =
            maybeGetASquareAt i (j + 1) matrix

        down_right : Maybe Square
        down_right =
            maybeGetASquareAt (i + 1) (j + 1) matrix
    in
    [ up_left, up_up, up_right, left_left, right_right, down_left, down_down, down_right ]
        |> List.filterMap toSquare


toSquare : Maybe Square -> Maybe Square
toSquare squareMaybe =
    case squareMaybe of
        Just square ->
            Just square

        Nothing ->
            Nothing



-- 1, 2, 3
-- 4, 5, 6
-- 7, 8, 9


getAllNine : Matrix -> Int -> Int -> Array.Array (Maybe Square)
getAllNine matrix i j =
    let
        up_left : Maybe Square
        up_left =
            maybeGetASquareAt (i - 1) (j - 1) matrix

        up_up : Maybe Square
        up_up =
            maybeGetASquareAt i (j - 1) matrix

        up_right : Maybe Square
        up_right =
            maybeGetASquareAt (i + 1) (j - 1) matrix

        left_left : Maybe Square
        left_left =
            maybeGetASquareAt (i - 1) j matrix

        right_right : Maybe Square
        right_right =
            maybeGetASquareAt (i + 1) j matrix

        down_left : Maybe Square
        down_left =
            maybeGetASquareAt (i - 1) (j + 1) matrix

        down_down : Maybe Square
        down_down =
            maybeGetASquareAt i (j + 1) matrix

        down_right : Maybe Square
        down_right =
            maybeGetASquareAt (i + 1) (j + 1) matrix

        center_center : Maybe Square
        center_center =
            maybeGetASquareAt i j matrix
    in
    Array.fromList [ up_left, up_up, up_right, left_left, right_right, down_left, down_down, down_right, center_center ]


generateDefaultMatrix : Int -> Int -> Matrix
generateDefaultMatrix n_columns n_rows =
    generateMatrixAndPopulateWithBaseSquare n_columns n_rows
        |> addIJIDtoMatrix



-- Generate Default Matrix Without Bomb. At first click, must get "JustAnEmptySquare"


generateMatrixAndPopulateWithBaseSquare : Int -> Int -> Matrix
generateMatrixAndPopulateWithBaseSquare n_columns n_rows =
    Array.repeat n_columns baseSquare
        |> Array.repeat n_rows


baseSquare : Square
baseSquare =
    { id = 0
    , i = 0
    , j = 0
    , square_content = JustAnEmptySquare
    , n_nabo_miner = 0
    , squareViewState = SquareViewStateClosed
    }


addIJIDtoMatrix : Matrix -> Matrix
addIJIDtoMatrix defaultMatrix =
    Array.indexedMap updateColumn defaultMatrix


updateColumn : Int -> Array Square -> Array Square
updateColumn column_index array_square =
    Array.indexedMap (updateSquareInRow column_index) array_square


updateSquareInRow : Int -> Int -> Square -> Square
updateSquareInRow column_index row_index aSquare =
    let
        currentSquareId =
            calculateSquareId row_index column_index
    in
    { id = currentSquareId
    , i = column_index + 1
    , j = row_index + 1
    , square_content = JustAnEmptySquare
    , n_nabo_miner = 0
    , squareViewState = SquareViewStateClosed
    }


calculateSquareId : Int -> Int -> Int
calculateSquareId row_index column_index =
    C.n_rows * row_index + column_index + 1


checkIfVictorious : Int -> Bool
checkIfVictorious n_opened_so_far_updated =
    if n_opened_so_far_updated == (C.n_squares - C.n_bombs) then
        True

    else
        False



-- Flagging


toggleFlagOnSquare : Matrix -> Square -> Matrix
toggleFlagOnSquare matrix squareToToggleFlag =
    let
        squareToToggleFlag_updated =
            case squareToToggleFlag.squareViewState of
                SquareViewStateClosed ->
                    { squareToToggleFlag | squareViewState = SquareViewStateFlagged }

                SquareViewStateOpen ->
                    squareToToggleFlag

                SquareViewStateFlagged ->
                    { squareToToggleFlag | squareViewState = SquareViewStateClosed }

        maybeColumnToUpdate =
            Array.get (squareToToggleFlag.i - 1) matrix

        arrayToBeUpdated_updated =
            updateArrayWithUpdatedSquare maybeColumnToUpdate squareToToggleFlag_updated
    in
    Array.set (squareToToggleFlag_updated.i - 1) arrayToBeUpdated_updated matrix



-- OPENING


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


getAllClosedNeighbours : Matrix -> Int -> Int -> List Square
getAllClosedNeighbours matrix i j =
    let
        neighbours =
            getAllNeighbours matrix i j
    in
    List.filter neighbourIsClosed neighbours


neighbourIsClosed : Square -> Bool
neighbourIsClosed aSquare =
    case aSquare.squareViewState of
        SquareViewStateClosed ->
            True

        _ ->
            False


keepSquareIfJustSquare : Maybe Square -> Maybe Square
keepSquareIfJustSquare maybeSquare =
    case maybeSquare of
        Just aSquare ->
            Just aSquare

        Nothing ->
            Nothing


neighbourIsClosedAndEmpty : Square -> Bool
neighbourIsClosedAndEmpty aSquare =
    case aSquare.squareViewState of
        SquareViewStateClosed ->
            case aSquare.square_content of
                JustAnEmptySquare ->
                    True

                _ ->
                    False

        _ ->
            False


neighbourIsEmpty : Square -> Bool
neighbourIsEmpty aSquare =
    case aSquare.square_content of
        JustAnEmptySquare ->
            True

        _ ->
            False


getListOfEmptyButStillClosedNeighbours : Matrix -> Int -> Int -> List Square
getListOfEmptyButStillClosedNeighbours matrix i j =
    let
        neighbours =
            getAllNeighbours matrix i j
    in
    List.filter neighbourIsClosedAndEmpty neighbours


getListOfEmptyNeighbours : Matrix -> Int -> Int -> List Square
getListOfEmptyNeighbours matrix i j =
    let
        neighbours =
            getAllNeighbours matrix i j
    in
    List.filter neighbourIsEmpty neighbours



-- END
