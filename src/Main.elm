module Main exposing (..)

import Html exposing (..)
import Keyboard
import Result exposing (Result(..))
import Msg exposing (..)
import Model exposing (..)
import View exposing (view)


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NewGame size ->
            ( Model.init size model.seed |> Model.shuffle 1000, Cmd.none )

        UpdateSeed value ->
            case String.toInt value of
                Ok seed ->
                    ( Model.updateSeed seed model, Cmd.none )

                Err _ ->
                    ( model, Cmd.none )

        HandleKey key ->
            case key of
                37 ->
                    ( Model.move Left model, Cmd.none )

                38 ->
                    ( Model.move Up model, Cmd.none )

                39 ->
                    ( Model.move Right model, Cmd.none )

                40 ->
                    ( Model.move Down model, Cmd.none )

                _ ->
                    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs HandleKey
        ]


init : ( Model, Cmd Msg )
init =
    ( Model.init 4 0, Cmd.none )
