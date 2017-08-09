module Model exposing (..)

import Array exposing (Array)
import Random


type Direction
    = Up
    | Down
    | Left
    | Right


toDirection : Int -> Direction
toDirection num =
    case (num % 4) of
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


type GameStatus
    = Initial
    | Solved
    | Shuffling
    | InGame


type alias Position =
    ( Int, Int )


type alias Model =
    { size : Int
    , seed : Int
    , cells : Array Cell
    , currentPos : Position
    , gameStatus : GameStatus
    }


startGame : Model -> Model
startGame model =
    init model.size model.seed
        |> setGameStatus Shuffling
        |> shuffle 1000
        |> setGameStatus InGame


setGameStatus : GameStatus -> Model -> Model
setGameStatus gameStatus model =
    { model | gameStatus = gameStatus }


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
        , gameStatus = Initial
        }


shuffle : Int -> Model -> Model
shuffle numMoves model =
    let
        dirListGenerator =
            Random.int 0 3
                |> Random.map toDirection
                |> Random.list numMoves

        ( dirList, nextSeed ) =
            Random.step dirListGenerator (Random.initialSeed model.seed)
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
        if ((model.gameStatus == InGame || model.gameStatus == Shuffling) && insideField nextPos model.size) then
            { model
                | currentPos = nextPos
                , cells = swapCells (toIndex model.currentPos model) (toIndex nextPos model) model.cells
            }
                |> recalculateGameStatus
        else
            model


recalculateGameStatus : Model -> Model
recalculateGameStatus model =
    let
        solved : Bool
        solved =
            List.map2
                (\cellInitial cellCurrent -> cellInitial == cellCurrent)
                (model.cells |> Array.toList)
                (init model.size model.seed |> .cells |> Array.toList)
                |> List.all (\isCorrect -> isCorrect)
    in
        if model.gameStatus == InGame && solved then
            setGameStatus Solved model
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
