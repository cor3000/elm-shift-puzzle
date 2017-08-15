module View exposing (view)

import Html exposing (Html, div, span, text, input, button, label)
import Html.Attributes exposing (id, class, style, type_, value, rel, href, for, checked)
import Html.Events exposing (onClick, onInput, onCheck)
import Html.CssHelpers
import Css
import Debug
import Array exposing (Array)
import Model exposing (..)
import Msg exposing (..)
import Styles.PuzzleCss as PuzzleCss


debug =
    Debug.log "CSS Compile Warnings" compiledStyles.warnings


compiledStyles =
    Css.compile [ PuzzleCss.css ]


css : Html.CssHelpers.Namespace String class id msg
css =
    PuzzleCss.helpers


toPx : number -> String
toPx num =
    toString num ++ "px"


view : Model -> Html Msg
view model =
    div [ css.class [ PuzzleCss.Wrapper ] ]
        [ Html.node "link"
            [ rel "stylesheet"
            , href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css"
            ]
            []
        , Html.CssHelpers.style compiledStyles.css
        , div [ css.class [ PuzzleCss.Sidebar ] ]
            [ div [ class "form-group row" ]
                [ label [ for "seedInput", class "col-form-label col-3" ]
                    [ text "Seed" ]
                , div [ class "col-9" ]
                    [ input
                        [ id "seedInput"
                        , class "form-control"
                        , type_ "number"
                        , value (toString model.seed)
                        , onInput (String.toInt >> Result.withDefault 0 >> UpdateSeed)
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
                                , checked (model.invertControls)
                                , onCheck (InvertControls)
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
                    [ text ("Moves " ++ (toString model.numMoves)) ]
                ]
            ]
        , div [ css.class [ PuzzleCss.Content ] ]
            [ div [ css.class [ PuzzleCss.Field ] ]
                (Array.map (cell model) model.cells |> Array.toList)
            ]
        ]


cell : Model -> Cell -> Html Msg
cell model cell =
    let
        scale =
            100.0 / toFloat model.size

        ( x, y ) =
            cell.pos

        posStyles =
            styles
                [ Css.top (Css.pct <| toFloat y * scale)
                , Css.left (Css.pct <| toFloat x * scale)
                ]
    in
        case cell.part of
            Number num ->
                div
                    [ posStyles
                    , css.classList
                        [ ( PuzzleCss.Cell, True )
                        , ( PuzzleCss.CellCorrect, cell.pos == cell.origin )
                        ]
                    ]
                    [ text (toString num) ]

            Empty ->
                div
                    [ posStyles
                    , css.class [ PuzzleCss.Cell, PuzzleCss.CellEmpty ]
                    ]
                    [ text <|
                        if model.gameStatus == InGame then
                            "😒"
                        else
                            "😀"
                    ]


styles : List Css.Style -> Html.Attribute msg
styles =
    Css.asPairs >> style
