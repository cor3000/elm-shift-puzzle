module Msg exposing (..)

import Keyboard exposing (KeyCode)


type Msg
    = NewGame Int
    | UpdateSeed String
    | HandleKey KeyCode
