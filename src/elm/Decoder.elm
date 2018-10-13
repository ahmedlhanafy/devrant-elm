module Decoder exposing (rantsResponseDecoder, rantResponseDecoder)

import Json.Decode as Decode exposing (int, string, float, Decoder, at, list, field, bool)
import Json.Decode.Pipeline exposing (required, optional, hardcoded)
import Types exposing (..)


rantsResponseDecoder : Decoder (List Rant)
rantsResponseDecoder =
    at [ "rants" ] (list rantDecoder)


rantResponseDecoder : Decoder RantResponse
rantResponseDecoder =
    Decode.succeed RantResponse
        |> required "rant" rantDecoder
        |> optional "comments" (list commentDecoder) []


rantDecoder : Decoder Rant
rantDecoder =
    Decode.succeed Rant
        |> required "text" string
        |> required "id" int
        |> required "attached_image" (Decode.maybe imageDecoder)
        |> required "user_username" string
        |> required "user_score" int
        |> required "num_comments" int
        |> required "tags" (list string)
        |> required "user_avatar" (Decode.maybe userAvatarDecoder)
        |> required "created_time" float
        |> required "user_id" int
        |> required "score" int
        |> optional "link" string ""


userAvatarDecoder : Decoder UserAvatar
userAvatarDecoder =
    Decode.succeed UserAvatar
        |> required "b" string
        |> required "i" string


imageDecoder : Decoder AttachedImage
imageDecoder =
    Decode.succeed AttachedImage
        |> required "url" string


commentDecoder : Decoder Comment
commentDecoder =
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
        |> required "user_avatar" (Decode.maybe userAvatarDecoder)
