module Main exposing (..)

import Html exposing (..)
import Debug
import View exposing (view)
import Msg exposing (..)
import Model exposing (..)


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
        Move dir ->
            ( Model.move dir model, Cmd.none )

        unhandled ->
            ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none


init : ( Model, Cmd Msg )
init =
    ( Model.init, Cmd.none )
