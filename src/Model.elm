module Model exposing (..)

import Array exposing (Array)
import Random
import Debug


type Direction
    = Up
    | Down
    | Left
    | Right


toDirection num =
    case num of
        0 ->
            Right

        1 ->
            Up

        2 ->
            Left

        _ ->
            Down


type Cell
    = Empty
    | Part Int


type alias Position =
    ( Int, Int )


type alias Model =
    { size : Int
    , seed : Int
    , cells : Array Cell
    , currentPos : ( Int, Int )
    }


startGame : Model -> Model
startGame model =
    init model.size model.seed
        |> shuffle 1000


init : Int -> Int -> Model
init size seed =
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
        , seed = seed
        }


shuffle : Int -> Model -> Model
shuffle numMoves model =
    let
        intListGenerator =
            Random.list numMoves (Random.int 0 3)

        ( intList, nextSeed ) =
            Random.step intListGenerator (Random.initialSeed model.seed)

        dirList =
            List.map toDirection intList
    in
        List.foldl move model dirList


updateSeed : Int -> Model -> Model
updateSeed seed model =
    { model | seed = seed }


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
    in
        if (insideField nextPos model.size) then
            { model
                | currentPos = nextPos
                , cells = swapCells (toIndex model.currentPos model) (toIndex nextPos model) model.cells
            }
        else
            model


swapCells : Int -> Int -> Array Cell -> Array Cell
swapCells index1 index2 cells =
    let
        maybeCell1 =
            Array.get index1 cells

        maybeCell2 =
            Array.get index2 cells
    in
        case ( maybeCell1, maybeCell2 ) of
            ( Just cell1, Just cell2 ) ->
                cells
                    |> Array.set index1 cell2
                    |> Array.set index2 cell1

            ( _, _ ) ->
                cells


insideField : Position -> Int -> Bool
insideField ( x, y ) size =
    x >= 0 && x < size && y >= 0 && y < size


toIndex : Position -> Model -> Int
toIndex ( x, y ) model =
    y * model.size + x
