module View exposing (view)

import Html exposing (Html, div, text, input, button, label)
import Html.Attributes exposing (id, class, style, type_, value, rel, href, for)
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
    div [ css.class [ PuzzleCss.Wrapper ] ]
        [ Html.node "link"
            [ rel "stylesheet"
            , href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css"
            ]
            []
        , Html.CssHelpers.style compiledStyles.css
        , div [ css.class [ PuzzleCss.Sidebar ] ]
            [ label [ for "seedInput", class "col-form-label" ]
                [ text "Seed: " ]
            , input
                [ id "seedInput"
                , class "form-control"
                , type_ "number"
                , value (toString model.seed)
                , onInput (String.toInt >> Result.withDefault 0 >> UpdateSeed)
                ]
                []
            , button [ class "btn btn-primary", onClick StartGame ]
                [ text "Start" ]
            , div []
                [ label [ for "seedInput", class "col-form-label" ]
                    [ text ("Moves: " ++ (toString model.numMoves)) ]
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
