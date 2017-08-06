module Model exposing (..)

import Array exposing (Array)


type Direction
    = Up
    | Down
    | Left
    | Right


type alias Model =
    { cells : Array Int
    , currentCell : Int
    }


init : Model
init =
    { cells = Array.initialize 15 identity |> Array.push 0
    , currentCell = 15
    }


move : Direction -> Model -> Model
move dir model =
    model
