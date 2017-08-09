module View exposing (view)

import Html exposing (Html, div, text, input, button)
import Html.Attributes exposing (style, type_, value)
import Html.Events exposing (onClick, onInput)
import Html.CssHelpers
import Css
import Debug
import Array exposing (Array)
import Model exposing (..)
import Msg exposing (..)
import Styles.PuzzleCss as PuzzleCss


compiledStyles =
    Css.compile [ PuzzleCss.css ]


debug =
    Debug.log "CSS Compile Warnings" compiledStyles.warnings


toPx : number -> String
toPx num =
    toString num ++ "px"


{ id, class, classList } =
    PuzzleCss.helpers


view : Model -> Html Msg
view model =
    div []
        [ Html.CssHelpers.style compiledStyles.css
        , div
            [ class [ PuzzleCss.Field ]
            ]
            (cells model)
        , text "Seed: "
        , input [ onInput (String.toInt >> UpdateSeed), type_ "number", value (toString model.seed) ] []
        , button [ onClick StartGame ] [ text "start" ]
        ]


cells : Model -> List (Html Msg)
cells model =
    let
        cellWithGameStatus : Int -> Cell -> Html Msg
        cellWithGameStatus =
            cell model.gameStatus
    in
        Array.indexedMap cellWithGameStatus model.cells
            |> Array.toList


cell : GameStatus -> Int -> Cell -> Html Msg
cell gameStatus index cell =
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
            div [ class [ PuzzleCss.Cell, PuzzleCss.CellEmpty ] ]
                [ if gameStatus == InGame then
                    (text "😒")
                  else
                    (text "😀")
                ]
