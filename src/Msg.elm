module Msg exposing (..)

import Keyboard exposing (KeyCode)


type Msg
    = StartGame
    | AbortGame
    | UpdateSeed (Result String Int)
    | HandleKey KeyCode
