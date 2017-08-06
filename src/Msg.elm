module Msg exposing (..)

import Model exposing (Direction)


type Msg
    = Move Direction
    | NewGame
    | ChangeSize
