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
    case (modBy 4 num) of
        0 ->
            Right

        1 ->
            Up

        2 ->
            Left

        _ ->
            Down


type Part
    = Empty
    | Number Int


type alias Cell =
    { index : Int
    , part : Part
    , origin : Position
    , pos : Position
    }


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
    , invertControls : Bool
    , currentPos : Position
    , gameStatus : GameStatus
    , numMoves : Int
    }


startGame : Model -> Model
startGame model =
    init model.size model.seed
        |> setGameStatus Shuffling
        |> shuffle 1000
        |> setGameStatus InGame
        |> (\m -> { m | numMoves = 0 })


setGameStatus : GameStatus -> Model -> Model
setGameStatus gameStatus model =
    { model | gameStatus = gameStatus }


init : Int -> Int -> Model
init size seed =
    let
        numParts =
            size ^ 2 - 1

        bottomRight =
            ( size - 1, size - 1 )

        emptyCell =
            Cell numParts Empty bottomRight bottomRight
    in
        { cells =
            Array.initialize numParts identity
                |> Array.map (partCellFrom size)
                |> Array.push emptyCell
        , currentPos = bottomRight
        , size = size
        , seed = seed
        , gameStatus = Initial
        , numMoves = 0
        , invertControls = False
        }


partCellFrom : Int -> Int -> Cell
partCellFrom size index =
    let
        pos =
            toPosition size index
    in
        Cell index (Number (index + 1)) pos pos


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


updateInvertControls : Bool -> Model -> Model
updateInvertControls invertControls model =
    { model | invertControls = invertControls }


move : Direction -> Model -> Model
move dir model =
    let
        ( x, y ) =
            model.currentPos

        invertFactor =
            if model.invertControls then
                -1
            else
                1

        nextPos : Position
        nextPos =
            case dir of
                Up ->
                    ( x, y - 1 * invertFactor )

                Down ->
                    ( x, y + 1 * invertFactor )

                Left ->
                    ( x - 1 * invertFactor, y )

                Right ->
                    ( x + 1 * invertFactor, y )
    in
        if ((model.gameStatus == InGame || model.gameStatus == Shuffling) && insideField model.size nextPos) then
            updateMove nextPos model
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
                |> List.all identity
    in
        if model.gameStatus == InGame && solved then
            setGameStatus Solved model
        else
            model


updateMove : Position -> Model -> Model
updateMove nextPos model =
    let
        currentCell : Maybe Cell
        currentCell =
            cellAtPosition model.currentPos model

        nextCell : Maybe Cell
        nextCell =
            cellAtPosition nextPos model
    in
        swapPositions currentCell nextCell model.cells
            |> Maybe.map
                (\cells ->
                    { model
                        | currentPos = nextPos
                        , cells = cells
                        , numMoves = (model.numMoves + 1)
                    }
                )
            |> Maybe.withDefault model


swapPositions : Maybe Cell -> Maybe Cell -> Array Cell -> Maybe (Array Cell)
swapPositions cell1 cell2 cells =
    Maybe.map2
        (\c1 c2 ->
            cells
                |> Array.set c1.index { c1 | pos = c2.pos }
                |> Array.set c2.index { c2 | pos = c1.pos }
        )
        cell1
        cell2


insideField : Int -> Position -> Bool
insideField size ( x, y ) =
    x >= 0 && x < size && y >= 0 && y < size


cellAtPosition : Position -> Model -> Maybe Cell
cellAtPosition pos model =
    Array.filter (.pos >> (==) pos) model.cells
        |> Array.get 0


toPosition : Int -> Int -> Position
toPosition size index =
    ( modBy size index, index // size )
