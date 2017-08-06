module Main exposing (..)

import Html exposing (..)
import Debug exposing (log)
import Array
import View exposing (view)
import Msg exposing (..)
import Model exposing (..)
import Maybe
import Keyboard


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
            ( Model.init size, Cmd.none )

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

        unhandled ->
            let
                _ =
                    log "unhandled Msg" msg
            in
                ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs HandleKey
        ]


init : ( Model, Cmd Msg )
init =
    ( Model.init 4, Cmd.none )
