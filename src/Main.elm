module Main exposing (init)

import Browser
import Browser.Events as Events
import GameKeyDecoder exposing (..)
import Html
import Json.Decode as Decode
import Model exposing (..)
import Msg exposing (..)
import View exposing (view)


main : Program Decode.Value Model Msg
main =
    Browser.document
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

        HandleKey LeftKey ->
            ( Model.move Left model, Cmd.none )

        HandleKey UpKey ->
            ( Model.move Up model, Cmd.none )

        HandleKey RightKey ->
            ( Model.move Right model, Cmd.none )

        HandleKey DownKey ->
            ( Model.move Down model, Cmd.none )

        HandleKey StartKey ->
            update Msg.StartGame model

        HandleKey AbortKey ->
            update Msg.AbortGame model

        HandleKey IncreaseSeedKey ->
            update (Msg.UpdateSeed (model.seed + 1)) model

        HandleKey DecreaseSeedKey ->
            update (Msg.UpdateSeed (model.seed - 1)) model

        HandleKey (Other key) ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Events.onKeyDown gameKeyDecoder
            |> Sub.map HandleKey
        ]


init : Decode.Value -> ( Model, Cmd Msg )
init flags =
    ( Model.init 4 0, Cmd.none )
