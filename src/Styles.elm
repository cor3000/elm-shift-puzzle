module Styles exposing (globalStyles, styles)

import Css exposing (..)
import Css.Global exposing (global, selector)
import Css.Transitions exposing (easeOut, transition)
import Html.Styled
import Html.Styled.Attributes exposing (href, rel)


colors =
    { navy = hex "#001F3F"
    , blue = hex "#0074D9"
    , aqua = hex "#7FDBFF"
    , teal = hex "#39CCCC"
    , olive = hex "#3D9970"
    , green = hex "#2ECC40"
    , lime = hex "#01FF70"
    , yellow = hex "#FFDC00"
    , orange = hex "#FF851B"
    , red = hex "#FF4136"
    , maroon = hex "#85144B"
    , fuchsia = hex "#F012BE"
    , purple = hex "#B10DC9"
    , black = hex "#111111"
    , gray = hex "#AAAAAA"
    , silver = hex "#DDDDDD"
    , white = hex "#FFFFFF"
    }


theme =
    { bgColor = colors.navy
    , fgColor = colors.orange
    }


globalStyles =
    [ Html.Styled.node "link" [ rel "stylesheet", href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0/css/bootstrap.min.css" ] []
    , global
        [ selector "body"
            [ backgroundColor theme.bgColor
            , color theme.fgColor
            ]
        ]
    ]


styles =
    { wrapper =
        Css.batch
            [ displayFlex
            , width (pct 100)
            ]
    , sidebar =
        Css.batch
            [ display inlineBlock
            , flex none
            , width (px 200)
            ]
    , content =
        Css.batch
            [ flex (int 1)
            , position relative
            ]
    , puzzleField =
        Css.batch
            [ display inlineBlock
            , width (vmin 80)
            , height (vmin 80)
            , margin2 zero (px 20)
            , position relative
            ]
    , puzzlePiece =
        Css.batch
            [ displayFlex
            , alignItems center
            , justifyContent center
            , boxSizing borderBox
            , position absolute
            , margin (pct 1)
            , width (pct 23)
            , height (pct 23)
            , fontSize (vmin 13)
            , textAlign center
            , textShadow4 (px 3) (px 3) (px 3) colors.black
            , borderRadius (pct 5)
            , transition
                [ Css.Transitions.left3 100 0 easeOut
                , Css.Transitions.top3 100 0 easeOut
                , Css.Transitions.color3 100 0 easeOut
                , Css.Transitions.backgroundColor3 100 0 easeOut
                ]
            ]
    , puzzlePieceCorrect =
        Css.batch
            [ backgroundColor colors.orange
            , color colors.yellow
            ]
    , puzzlePieceWrong =
        Css.batch
            [ backgroundColor colors.gray
            , color colors.silver
            ]
    , puzzlePieceEmpty =
        Css.batch
            [ backgroundColor transparent
            , color colors.gray
            ]
    }
