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


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        StartGame ->
            ( Model.startGame model, Cmd.none )

        AbortGame ->
            ( Model.init model.size model.seed, Cmd.none )

        UpdateSeed res ->
            case res of
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

                13 ->
                    update Msg.StartGame model

                27 ->
                    update Msg.AbortGame model

                33 ->
                    update (Msg.UpdateSeed <| Ok (model.seed + 1)) model

                34 ->
                    update (Msg.UpdateSeed <| Ok (model.seed - 1)) model

                k ->
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
