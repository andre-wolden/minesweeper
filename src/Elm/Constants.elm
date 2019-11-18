module Elm.Constants exposing (darkGrey, grey, lightGrey, n_bombs, n_columns, n_rows, n_squares, squareWidth, totalHeight, totalWidth)


n_bombs : Int
n_bombs =
    99


n_squares : Int
n_squares =
    n_rows * n_columns


n_rows : Int
n_rows =
    16


n_columns : Int
n_columns =
    30


squareWidth : Int
squareWidth =
    32


lightGrey =
    "rgb(250,250,250)"


grey =
    "rgb(169,169,169)"


darkGrey =
    "rgb(105,105,105)"


totalWidth =
    "1024"


totalHeight =
    "480"
