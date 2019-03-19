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

        Move direction ->
            ( Model.move direction model, Cmd.none )

        AbortGame ->
            ( Model.abortGame model, Cmd.none )

        UpdateSeed seed ->
            ( Model.updateSeed seed model, Cmd.none )

        InvertControls flag ->
            ( Model.updateInvertControls flag model, Cmd.none )

        HandleKey key ->
            handleKeys key model


handleKeys key model =
    case key of
        LeftKey ->
            update (Msg.Move Left) model

        UpKey ->
            update (Msg.Move Up) model

        RightKey ->
            update (Msg.Move Right) model

        DownKey ->
            update (Msg.Move Down) model

        StartKey ->
            update Msg.StartGame model

        AbortKey ->
            update Msg.AbortGame model

        IncreaseSeedKey ->
            update (Msg.UpdateSeed (model.seed + 1)) model

        DecreaseSeedKey ->
            update (Msg.UpdateSeed (model.seed - 1)) model

        Other _ ->
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
