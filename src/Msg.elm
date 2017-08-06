module Msg exposing (..)

import Model exposing (Direction)
import Keyboard exposing (KeyCode)


type Msg
    = NewGame Int
    | ChangeSize Int
    | HandleKey KeyCode
