module View exposing (..)

import Html exposing (Html, div, text)
import Model exposing (..)
import Msg exposing (..)


view : Model -> Html Msg
view model =
    div []
        [ text (toString model)
        ]
