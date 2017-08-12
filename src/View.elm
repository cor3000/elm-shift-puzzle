module View exposing (view)

import Html exposing (Html, div, text, input, button, label)
import Html.Attributes exposing (class, style, type_, value, rel, href, for)
import Html.Events exposing (onClick, onInput)
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
    div [ class "container" ]
        [ Html.node "link"
            [ rel "stylesheet"
            , href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css"
            ]
            []
        , Html.CssHelpers.style compiledStyles.css
        , div
            [ css.class [ PuzzleCss.Field ]
            ]
            (Array.map (cell model) model.cells |> Array.toList)
        , div [ class "form-group row" ]
            [ div [ class "col-3" ] []
            , label [ for "seedInput", class "col-2 col-form-label" ]
                [ text "Seed: " ]
            , input
                [ class "col-2 form-control"
                , onInput (String.toInt >> Result.withDefault 0 >> UpdateSeed)
                , type_ "number"
                , value (toString model.seed)
                ]
                []
            , button
                [ class "btn btn-primary col-2"
                , onClick StartGame
                ]
                [ text "Start" ]
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
