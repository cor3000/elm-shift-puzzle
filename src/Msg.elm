module Msg exposing (..)

import Keyboard exposing (KeyCode)


type Msg
    = StartGame
    | AbortGame
    | UpdateSeed Int
    | HandleKey KeyCode
