module Model exposing (..)

import Array exposing (Array)


type Direction
    = Up
    | Down
    | Left
    | Right


type Cell
    = Empty
    | Part Int


type alias Position =
    ( Int, Int )


type alias Model =
    { size : Int
    , cells : Array Cell
    , currentPos : ( Int, Int )
    }


init : Int -> Model
init size =
    let
        numParts =
            size ^ 2 - 1
    in
        { cells =
            Array.initialize numParts identity
                |> Array.map (\index -> Part index)
                |> Array.push Empty
        , currentPos = ( size - 1, size - 1 )
        , size = size
        }


move : Direction -> Model -> Model
move dir model =
    let
        ( x, y ) =
            model.currentPos

        nextPos =
            case dir of
                Up ->
                    ( x, y - 1 )

                Down ->
                    ( x, y + 1 )

                Left ->
                    ( x - 1, y )

                Right ->
                    ( x + 1, y )

        maybeCell =
            cellAt nextPos model
    in
        case maybeCell of
            Just cell ->
                { model
                    | currentPos = nextPos
                    , cells =
                        model.cells
                            |> Array.set (toIndex ( x, y ) model) cell
                            |> Array.set (toIndex nextPos model) Empty
                }

            Nothing ->
                model


cellAt : Position -> Model -> Maybe Cell
cellAt ( x, y ) model =
    let
        insideField =
            x >= 0 && x < model.size && y >= 0 && y < model.size
    in
        if insideField then
            Array.get (toIndex ( x, y ) model) model.cells
        else
            Nothing


toIndex : Position -> Model -> Int
toIndex ( x, y ) model =
    y * model.size + x
