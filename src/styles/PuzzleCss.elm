module PuzzleCss exposing (..)

import Css exposing (..)
import Css.Colors exposing (..)
import Css.Namespace exposing (namespace)
import Html.CssHelpers


type CssClasses
    = Cell
    | CellEmpty
    | CellCorrect


cellSize : number
cellSize =
    120


white : Color
white =
    hex "ffffff"


puzzleNamespace : String
puzzleNamespace =
    "puzzle"


helpers : Html.CssHelpers.Namespace String class id msg
helpers =
    Html.CssHelpers.withNamespace puzzleNamespace


css : Stylesheet
css =
    (stylesheet << namespace puzzleNamespace)
        [ class Cell
            [ display inlineBlock
            , boxSizing borderBox
            , width (px cellSize)
            , height (px cellSize)
            , lineHeight (px cellSize)
            , fontSize (px (cellSize * 0.7))
            , textAlign center
            , backgroundColor gray
            , color silver
            , borderRadius (px (cellSize * 0.1))
            , border3 (px 2) solid white
            ]
        , class CellCorrect
            [ backgroundColor green
            , color yellow
            ]
        , class CellEmpty
            [ backgroundColor white
            , color gray
            ]
        ]
