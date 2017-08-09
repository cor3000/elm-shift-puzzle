module Styles.PuzzleCss exposing (..)

import Css exposing (..)
import Css.Colors exposing (..)
import Css.Elements exposing (body)
import Css.Namespace exposing (namespace)
import Html.CssHelpers


type CssClasses
    = Cell
    | CellEmpty
    | CellCorrect
    | Field


cellSize : number
cellSize =
    120


white : Color
white =
    hex "ffffff"


puzzleBackgroundColor : Color
puzzleBackgroundColor =
    navy


puzzleNamespace : String
puzzleNamespace =
    "puzzle"


helpers : Html.CssHelpers.Namespace String class id msg
helpers =
    Html.CssHelpers.withNamespace puzzleNamespace


css : Stylesheet
css =
    (stylesheet << namespace puzzleNamespace)
        [ body
            [ backgroundColor puzzleBackgroundColor
            , color white
            , fontFamily sansSerif
            ]
        , class Field
            [ width (vmin 80)
            , height (vmin 80)
            , margin4 (vmin 2) auto zero auto
            ]
        , class Cell
            [ display inlineBlock
            , boxSizing borderBox
            , margin (pct 1)
            , width (pct 23)
            , height (pct 23)
            , fontSize (vmin 13)
            , lineHeight (vmin 20)
            , textAlign center
            , backgroundColor gray
            , color silver
            , borderRadius (px (cellSize * 0.1))
            ]
        , class CellCorrect
            [ backgroundColor orange
            , color yellow
            ]
        , class CellEmpty
            [ backgroundColor puzzleBackgroundColor
            , color gray
            ]
        ]
