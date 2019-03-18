module View exposing (view)

import Array
import Browser
import Css exposing (..)
import Css.Global exposing (global, selector)
import Css.Transitions exposing (easeOut, transition)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, href, src, style)
import Html.Styled.Events exposing (onClick)
import Model exposing (..)
import Msg exposing (..)


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


styles =
    { puzzlePiece =
        Css.batch
            [ display inlineBlock
            , boxSizing borderBox
            , position absolute
            , margin (pct 1)
            , width (pct 23)
            , height (pct 23)
            , fontSize (vmin 13)
            , lineHeight (vmin 20)
            , textAlign center
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
    , puzzleField =
        Css.batch
            [ display inlineBlock
            , width (vmin 80)
            , height (vmin 80)
            , margin2 zero (px 20)
            , position relative
            ]
    }


gameField : Model -> Html Msg
gameField model =
    div [ css [ styles.puzzleField ] ]
        [ text ("Moves: " ++ String.fromInt model.numMoves)
        , div []
            (Array.map (piece model) model.cells |> Array.toList)
        ]


piece : Model -> Cell -> Html Msg
piece model cell =
    let
        scale =
            100.0 / toFloat model.size

        ( x, y ) =
            cell.pos

        posStyles =
            Css.batch
                [ top (pct <| toFloat y * scale)
                , left (pct <| toFloat x * scale)
                ]

        statusStyle =
            if cell.pos == cell.origin then
                styles.puzzlePieceCorrect

            else
                styles.puzzlePieceWrong

        cssClasses =
            [ css [ styles.puzzlePiece ]
            , css [ posStyles ]
            , css [ statusStyle ]
            ]
    in
    case cell.part of
        Number num ->
            div
                cssClasses
                [ text (String.fromInt num) ]

        Empty ->
            div
                [ css [ styles.puzzlePiece ]
                , css [ styles.puzzlePieceEmpty ]
                , css [ posStyles ]
                ]
                [ text "😒" ]


view : Model -> Browser.Document Msg
view model =
    { title = "Shift Puzzle"
    , body =
        List.map toUnstyled
            [ global
                [ selector "body"
                    [ backgroundColor theme.bgColor
                    , color theme.fgColor
                    ]
                ]
            , gameField model
            ]
    }



-- import Styles.PuzzleCss as PuzzleCss
-- debug =
--     Debug.log "CSS Compile Warnings" compiledStyles.warnings
-- compiledStyles =
--     Css.compile [ PuzzleCss.css ]
-- css : Html.CssHelpers.Namespace String class id msg
-- css =
--     PuzzleCss.helpers
-- toPx : number -> String
-- toPx num =
--     toString num ++ "px"
-- view : Model -> Html Msg
-- view model =
--     div [ css.class [ PuzzleCss.Wrapper ] ]
--         [ Html.node "link"
--             [ rel "stylesheet"
--             , href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css"
--             ]
--             []
--         -- , Html.CssHelpers.style compiledStyles.css
--         , div [ css.class [ PuzzleCss.Sidebar ] ]
--             [ div [ class "form-group row" ]
--                 [ label [ for "seedInput", class "col-form-label col-3" ]
--                     [ text "Seed" ]
--                 , div [ class "col-9" ]
--                     [ input
--                         [ id "seedInput"
--                         , class "form-control"
--                         , type_ "number"
--                         , value (toString model.seed)
--                         , onInput (String.toInt >> Result.withDefault 0 >> UpdateSeed)
--                         ]
--                         []
--                     ]
--                 ]
--             , div [ class "form-group row" ]
--                 [ div [ class "offset-3 col-9" ]
--                     [ div [ class "form-check" ]
--                         [ label [ class "form-check-label" ]
--                             [ input
--                                 [ class "form-check-input"
--                                 , type_ "checkbox"
--                                 , checked model.invertControls
--                                 , onCheck InvertControls
--                                 ]
--                                 []
--                             , text " Invert Controls"
--                             ]
--                         ]
--                     ]
--                 ]
--             , div [ class "form-group row" ]
--                 [ div [ class "offset-3 col-9" ]
--                     [ button [ class "btn btn-primary", onClick StartGame ]
--                         [ text "Start" ]
--                     ]
--                 ]
--             , div [ class "form-group row" ]
--                 [ label [ class "col-form-label col-12" ]
--                     [ text ("Moves " ++ toString model.numMoves) ]
--                 ]
--             ]
--         , div [ css.class [ PuzzleCss.Content ] ]
--             [ div [ css.class [ PuzzleCss.Field ] ]
--                 (Array.map (cell model) model.cells |> Array.toList)
--             ]
--         ]
-- piece : Model -> Cell -> Html Msg
-- piece model cell =
--     let
--         scale =
--             100.0 / toFloat model.size
--         ( x, y ) =
--             cell.pos
--         posStyles =
--             styles
--                 [ Css.top (Css.pct <| toFloat y * scale)
--                 , Css.left (Css.pct <| toFloat x * scale)
--                 ]
--     in
--     case cell.part of
--         Number num ->
--             div
--                 [ posStyles
--                 , css.classList
--                     [ ( PuzzleCss.Cell, True )
--                     , ( PuzzleCss.CellCorrect, cell.pos == cell.origin )
--                     ]
--                 ]
--                 [ text (toString num) ]
--         Empty ->
--             div
--                 [ posStyles
--                 , css.class [ PuzzleCss.Cell, PuzzleCss.CellEmpty ]
--                 ]
--                 [ text <|
--                     if model.gameStatus == InGame then
--                         "😒"
--                     else
--                         "😀"
--                 ]
-- styles : List Css.Style -> Html.Attribute msg
-- styles =
--     Css.asPairs >> style
