module GameKeyDecoder exposing (GameKey(..), gameKeyDecoder)

import Json.Decode as Decode


type GameKey
    = UpKey
    | DownKey
    | LeftKey
    | RightKey
    | StartKey
    | AbortKey
    | IncreaseSeedKey
    | DecreaseSeedKey
    | Other String


toGameKey : String -> GameKey
toGameKey key =
    case key of
        "ArrowLeft" ->
            LeftKey

        "ArrowRight" ->
            RightKey

        "ArrowDown" ->
            DownKey

        "ArrowUp" ->
            UpKey

        "Enter" ->
            StartKey

        "PageUp" ->
            IncreaseSeedKey

        "PageDown" ->
            DecreaseSeedKey

        "Escape" ->
            AbortKey

        _ ->
            Other key


gameKeyDecoder : Decode.Decoder GameKey
gameKeyDecoder =
    Decode.map toGameKey (Decode.field "key" Decode.string)
