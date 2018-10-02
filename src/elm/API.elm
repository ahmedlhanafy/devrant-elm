module API exposing (getRants)

import String exposing (fromInt)
import Http exposing (send, Error)
import Json.Decode as Decode exposing (int, string, float, Decoder, at, list, field, bool)
import Json.Decode.Pipeline exposing (required, optional, hardcoded)
import Types exposing (..)
import Msg exposing (..)


getRants : Int -> Cmd Msg
getRants pageIndex =
    send SetRants (Http.get "https://www.devrant.io/api/devrant/rants?app=3&sort=algo" decodeRants)


decodeRants : Decoder (List Rant)
decodeRants =
    at [ "rants" ] (list decodeRant)


decodeRant : Decoder Rant
decodeRant =
    Decode.succeed Rant
        |> required "text" string
        |> required "id" int
        |> required "attached_image" (Decode.maybe decodeImage)
        |> required "user_username" string
        |> required "user_score" int
        |> required "num_comments" int
        |> required "tags" (list string)
        |> required "user_avatar" (Decode.maybe decodeUserAvatar)
        |> required "created_time" float
        |> required "user_id" int
        |> required "score" int
        |> optional "link" string ""


decodeUserAvatar : Decoder UserAvatar
decodeUserAvatar =
    Decode.succeed UserAvatar
        |> required "b" string
        |> required "i" string


decodeImage : Decoder AttachedImage
decodeImage =
    Decode.succeed AttachedImage
        |> required "url" string


decodeComment : Decoder Comment
decodeComment =
    Decode.succeed Comment
        |> required "id" int
        |> required "rant_id" int
        |> required "body" string
        |> required "score" int
        |> required "created_time" float
        |> required "vote_state" int
        |> required "user_id" int
        |> required "user_username" string
        |> required "user_score" int
        |> required "user_avatar" (Decode.maybe decodeUserAvatar)
