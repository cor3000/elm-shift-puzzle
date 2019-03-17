module Msg exposing (Msg(..))

import GameKeyDecoder exposing (GameKey)


type Msg
    = StartGame
    | AbortGame
    | UpdateSeed Int
    | InvertControls Bool
    | HandleKey GameKey
