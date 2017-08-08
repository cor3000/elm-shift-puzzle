module View exposing (view)

import Html exposing (Html, body, div, text, input, button)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick, onInput)
import Html.CssHelpers exposing (stylesheetLink)
import Array exposing (Array)
import Model exposing (..)
import Msg exposing (..)
import PuzzleCss exposing (..)


toPx : number -> String
toPx num =
    toString num ++ "px"


{ id, class, classList } =
    PuzzleCss.helpers


view : Model -> Html Msg
view model =
    body []
        [ stylesheetLink "/build/index.css"
        , div [ style [ ( "width", toPx (cellSize * model.size) ) ] ] (cells model.cells)
        , text "Seed: "
        , input [ onInput UpdateSeed, type_ "number", value <| toString model.seed ] []
        , button [ onClick StartGame ] [ text "start" ]
        ]


cells : Array Cell -> List (Html Msg)
cells cells =
    Array.indexedMap cell cells
        |> Array.toList


cell : Int -> Cell -> Html Msg
cell index cell =
    case cell of
        Part number ->
            div
                [ classList
                    [ ( PuzzleCss.Cell, True )
                    , ( PuzzleCss.CellCorrect, number == index )
                    ]
                ]
                [ text (number + 1 |> toString) ]

        Empty ->
            div [ class [ PuzzleCss.Cell, PuzzleCss.CellEmpty ] ] [ text "😒" ]
