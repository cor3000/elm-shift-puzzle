module Styles.PuzzleCss exposing (..)

import Css exposing (..)
import Css.Colors exposing (..)
import Css.Elements exposing (body)
import Css.Namespace exposing (namespace)
import Html.CssHelpers


type CssClasses
    = Wrapper
    | Sidebar
    | Content
    | Field
    | Cell
    | CellEmpty
    | CellCorrect


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


transition : List String -> Style
transition properties =
    property "transition" <| String.join "," properties


css : Stylesheet
css =
    (stylesheet << namespace puzzleNamespace)
        [ body
            [ backgroundColor puzzleBackgroundColor
            , color white
            , fontFamily sansSerif
            ]
        , class Wrapper
            [ displayFlex
            , width (pct 100)
            ]
        , class Sidebar
            [ display inlineBlock
            , flex none
            , width (px 200)
            ]
        , class Content
            [ flex (int 1)
            , position relative
            ]
        , class Field
            [ display inlineBlock
            , width (vmin 80)
            , height (vmin 80)
            , margin2 zero (px 20)
            , position relative
            ]
        , class Cell
            [ display inlineBlock
            , boxSizing borderBox
            , position absolute
            , margin (pct 1)
            , width (pct 23)
            , height (pct 23)
            , fontSize (vmin 13)
            , lineHeight (vmin 20)
            , textAlign center
            , backgroundColor gray
            , color silver
            , borderRadius (pct 5)
            , transition [ "left 0.1s ease-out", "top 0.1s ease-out" ]
            ]
        , class CellCorrect
            [ backgroundColor orange
            , color yellow
            ]
        , class CellEmpty
            [ backgroundColor transparent
            , color gray
            ]
        ]
