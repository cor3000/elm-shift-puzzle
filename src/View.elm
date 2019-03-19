module View exposing (view)

import Array
import Browser
import Css exposing (..)
import Css.Global exposing (global, selector)
import Css.Transitions exposing (easeOut, transition)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (checked, class, css, for, href, id, rel, src, style, type_, value)
import Html.Styled.Events exposing (onCheck, onClick, onInput)
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
    }


view : Model -> Browser.Document Msg
view model =
    { title = "Shift Puzzle"
    , body =
        List.map toUnstyled
            (globalStyles
                ++ [ div [ css [ styles.wrapper ] ]
                        [ sidebar model
                        , div [ css [ styles.content ] ]
                            [ gameField model
                            ]
                        ]
                   ]
            )
    }


gameField : Model -> Html Msg
gameField model =
    div [ css [ styles.puzzleField ] ]
        [ div []
            (Array.map (piece model) model.cells |> Array.toList)
        ]


piece : Model -> Cell -> Html Msg
piece model cell =
    let
        scale =
            100.0 / toFloat model.size

        ( x, y ) =
            cell.pos

        positionStyle =
            Css.batch
                [ top (pct <| toFloat y * scale)
                , left (pct <| toFloat x * scale)
                ]

        statusStyle =
            case cellStatus cell of
                CorrectPosition ->
                    styles.puzzlePieceCorrect

                WrongPosition ->
                    styles.puzzlePieceWrong

                EmptyCell ->
                    styles.puzzlePieceEmpty

        cssClasses =
            [ css [ styles.puzzlePiece ]
            , css [ positionStyle ]
            , css [ statusStyle ]
            ]
    in
    case cell.part of
        Number num ->
            div cssClasses [ text (String.fromInt num) ]

        Empty ->
            div cssClasses
                [ text
                    (case model.gameStatus of
                        InGame ->
                            "😒"

                        _ ->
                            "😀"
                    )
                ]


sidebar : Model -> Html Msg
sidebar model =
    div [ css [ styles.sidebar ] ]
        [ div [ class "form-group row" ]
            [ label [ for "seedInput", class "col-form-label col-3" ]
                [ text "Seed" ]
            , div [ class "col-9" ]
                [ input
                    [ id "seedInput"
                    , class "form-control"
                    , type_ "number"
                    , value (String.fromInt model.seed)
                    , onInput (String.toInt >> Maybe.withDefault 0 >> UpdateSeed)
                    ]
                    []
                ]
            ]
        , div [ class "form-group row" ]
            [ div [ class "offset-3 col-9" ]
                [ div [ class "form-check" ]
                    [ label [ class "form-check-label" ]
                        [ input
                            [ class "form-check-input"
                            , type_ "checkbox"
                            , checked model.invertControls
                            , onCheck InvertControls
                            ]
                            []
                        , text " Invert Controls"
                        ]
                    ]
                ]
            ]
        , div [ class "form-group row" ]
            [ div [ class "offset-3 col-9" ]
                [ button [ class "btn btn-primary", onClick StartGame ]
                    [ text "Start" ]
                ]
            ]
        , div [ class "form-group row" ]
            [ label [ class "col-form-label col-12" ]
                [ text ("Moves " ++ String.fromInt model.numMoves) ]
            ]
        ]



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
-- styles : List Css.Style -> Html.Attribute msg
-- styles =
--     Css.asPairs >> style
