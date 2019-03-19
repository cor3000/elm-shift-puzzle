module Msg exposing (Msg(..))

import GameKeyDecoder exposing (GameKey)
import Model exposing (Direction)


type Msg
    = StartGame
    | AbortGame
    | UpdateSeed Int
    | InvertControls Bool
    | Move Direction
    | HandleKey GameKey
