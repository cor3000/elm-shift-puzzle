module Msg exposing (Msg(..))

import GameKeyDecoder
import Model


type Msg
    = StartGame
    | AbortGame
    | UpdateSeed Int
    | InvertControls Bool
    | Move Model.Direction
    | HandleKey GameKeyDecoder.GameKey
