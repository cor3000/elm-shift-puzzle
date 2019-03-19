module View exposing (view)

import Array
import Browser
import Css exposing (left, pct, top)
import Html.Styled exposing (Html, button, div, input, label, text, toUnstyled)
import Html.Styled.Attributes exposing (checked, class, css, for, id, src, style, type_, value)
import Html.Styled.Events exposing (onCheck, onClick, onInput)
import Model exposing (Cell, CellStatus(..), GameStatus(..), Model, Part(..), cellStatus)
import Msg exposing (..)
import Styles exposing (globalStyles, styles)


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
