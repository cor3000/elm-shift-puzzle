module View exposing (view)

import Html exposing (Html, div, text, input, button, label)
import Html.Attributes as Attr exposing (style, type_, value, rel, href)
import Html.Events exposing (onClick, onInput)
import Html.CssHelpers
import Css
import Debug
import Array exposing (Array)
import Model exposing (..)
import Msg exposing (..)
import Styles.PuzzleCss as PuzzleCss


compiledStyles =
    Css.compile [ PuzzleCss.css ]


debug =
    Debug.log "CSS Compile Warnings" compiledStyles.warnings


toPx : number -> String
toPx num =
    toString num ++ "px"


{ id, class, classList } =
    PuzzleCss.helpers


view : Model -> Html Msg
view model =
    div [ Attr.class "container" ]
        [ Html.node "link"
            [ Attr.rel "stylesheet"
            , Attr.href "https://maxcdn.bootstrapcdn.com/bootstrap/4.0.0-alpha.6/css/bootstrap.min.css"
            ]
            []
        , Html.CssHelpers.style compiledStyles.css
        , div
            [ class [ PuzzleCss.Field ]
            ]
            (cells model)
        , div [ Attr.class "form-group row" ]
            [ div [ Attr.class "col-3" ] []
            , label [ Attr.for "seedInput", Attr.class "col-2 col-form-label" ]
                [ text "Seed: " ]
            , input
                [ Attr.class "col-2 form-control"
                , onInput (String.toInt >> Result.withDefault 0 >> UpdateSeed)
                , type_ "number"
                , value (toString model.seed)
                ]
                []
            , button
                [ Attr.class "btn btn-primary col-2"
                , onClick StartGame
                ]
                [ text "Start" ]
            ]
        ]


cells : Model -> List (Html Msg)
cells model =
    let
        cellWithGameStatus : Int -> Cell -> Html Msg
        cellWithGameStatus =
            cell model.gameStatus
    in
        Array.indexedMap cellWithGameStatus model.cells
            |> Array.toList


cell : GameStatus -> Int -> Cell -> Html Msg
cell gameStatus index cell =
    case cell of
        Part number ->
            div
                [ classList
                    [ ( PuzzleCss.Cell, True )
                    , ( PuzzleCss.CellCorrect, number == index )
                    ]
                ]
                [ text (number + 1 |> toString) ]

        Empty ->
            div [ class [ PuzzleCss.Cell, PuzzleCss.CellEmpty ] ]
                [ if gameStatus == InGame then
                    (text "😒")
                  else
                    (text "😀")
                ]
