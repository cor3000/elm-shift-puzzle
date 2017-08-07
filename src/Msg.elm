module Msg exposing (..)

import Keyboard exposing (KeyCode)


type Msg
    = StartGame
    | UpdateSeed String
    | HandleKey KeyCode
