module Main exposing (..)

import Html exposing (..)
import Keyboard
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


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        StartGame ->
            ( Model.startGame model, Cmd.none )

        AbortGame ->
            ( Model.init model.size model.seed, Cmd.none )

        UpdateSeed seed ->
            ( Model.updateSeed seed model, Cmd.none )

        InvertControls flag ->
            ( Model.updateInvertControls flag model, Cmd.none )

        HandleKey 37 ->
            ( Model.move Left model, Cmd.none )

        HandleKey 38 ->
            ( Model.move Up model, Cmd.none )

        HandleKey 39 ->
            ( Model.move Right model, Cmd.none )

        HandleKey 40 ->
            ( Model.move Down model, Cmd.none )

        HandleKey 13 ->
            update Msg.StartGame model

        HandleKey 27 ->
            update Msg.AbortGame model

        HandleKey 33 ->
            update (Msg.UpdateSeed (model.seed + 1)) model

        HandleKey 34 ->
            update (Msg.UpdateSeed (model.seed - 1)) model

        HandleKey k ->
            let
                unused =
                    Debug.log "unhandled keydown: " k
            in
                ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Keyboard.downs HandleKey
        ]


init : ( Model, Cmd Msg )
init =
    ( Model.init 4 0, Cmd.none )
