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
            (cells model)
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


cells : Model -> List (Html Msg)
cells model =
    Array.indexedMap (cell model) model.cells
        |> Array.toList


cell : Model -> Int -> Cell -> Html Msg
cell model index cell =
    let
        scale =
            100.0 / toFloat model.size

        ( x, y ) =
            toPosition index model

        posStyles =
            styles
                [ Css.top (Css.pct <| toFloat y * scale)
                , Css.left (Css.pct <| toFloat x * scale)
                ]
    in
        case cell of
            Part number ->
                div
                    [ posStyles
                    , css.classList
                        [ ( PuzzleCss.Cell, True )
                        , ( PuzzleCss.CellCorrect, number == index )
                        ]
                    ]
                    [ text (number + 1 |> toString) ]

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
