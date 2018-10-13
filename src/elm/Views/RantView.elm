module Views.RantView exposing (rantView)

import Html
import Url.Builder as Url
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, src, href)
import Html.Styled.Events exposing (onClick)
import Types exposing (..)
import Time exposing (Posix, millisToPosix)
import Views.Common exposing (..)
import Views.Theme exposing (theme)
import Time.Distance as Distance
import String exposing (fromInt, toFloat)


rantViewHeader : Posix -> { userAvatar : Maybe UserAvatar, userUsername : String, userScore : Int, createdTime : Posix } -> Html msg
rantViewHeader currentTime { userAvatar, userUsername, userScore, createdTime } =
    div
        [ css
            [ displayFlex
            , flexDirection row
            , alignItems center
            , marginBottom (px 16)
            ]
        ]
        [ avatarView
            userAvatar
        , div
            [ css
                [ flex (int 1)
                , cursor pointer
                ]
            ]
            [ span
                [ css
                    [ fontSize (px 16)
                    , fontWeight (int 600)
                    , color theme.primaryText
                    , marginLeft (px 16)
                    , displayFlex
                    , alignItems center
                    ]
                ]
                [ text userUsername
                , span
                    [ css
                        [ borderRadius (px 4)
                        , fontSize (px 12)
                        , marginLeft (px 12)
                        , padding (px 8)
                        , height (px 12)
                        , displayFlex
                        , justifyContent center
                        , alignItems center
                        , backgroundColor (rgba 255 255 255 0.2)
                        ]
                    ]
                    [ text <| fromInt <| userScore ]
                ]
            ]
        , span
            [ css
                [ fontSize (px 11)
                , color theme.secondaryText
                ]
            ]
            [ createdTime
                |> Distance.inWords currentTime
                |> text
            ]
        ]


rantViewText rantText =
    span
        [ css
            [ color theme.primaryText
            , fontSize (px 14)
            , letterSpacing (px 0.2)
            , flex (int 1)
            ]
        ]
        [ text rantText ]


toPosix created_time =
    created_time
        |> (*) 1000
        |> Basics.round
        |> millisToPosix


rantView : Posix -> List Comment -> Rant -> Html msg
rantView currentTime comments rant =
    li [ css [ listStyle none ] ]
        [ div
            [ css
                [ borderBottom3 (px 1) solid theme.border
                , displayFlex
                , flexDirection column
                , margin2 (px 0) (px 2)
                , padding (px 16)
                ]
            ]
            [ Html.Styled.a
                [ css [ textDecoration none ]
                , href (Url.absolute [ "rant", String.fromInt rant.id ] [])
                ]
                [ rantViewHeader currentTime
                    { userAvatar = rant.user_avatar
                    , userUsername = rant.user_username
                    , userScore = rant.user_score
                    , createdTime = toPosix rant.created_time
                    }
                , div
                    [ css
                        [ displayFlex
                        , flexDirection row
                        , justifyContent center
                        , alignItems flexStart
                        , marginBottom (px 16)
                        ]
                    ]
                    [ rantViewText rant.text
                    ]
                , rantImageView
                    [ css
                        [ width (pct 100)
                        , borderRadius (px 6)
                        , marginTop (px 8)
                        , marginBottom (px 16)
                        ]
                    ]
                    rant.attached_image
                , div
                    [ css
                        [ displayFlex
                        , flexWrap wrap
                        ]
                    ]
                    (List.map tagView rant.tags)
                ]
            ]
        , commentsView currentTime comments
        ]


commentsView : Posix -> List Comment -> Html msg
commentsView currentTime comments =
    case comments of
        [] ->
            span [] []

        list ->
            div
                [ css
                    [ displayFlex
                    , flexDirection column
                    , margin2 (px 0) (px 2)
                    , padding (px 16)
                    ]
                ]
                [ span
                    [ css
                        [ color (rgb 255 255 255)
                        , fontWeight bold
                        , fontSize (px 20)
                        ]
                    ]
                    [ text ("Comments(" ++ String.fromInt (List.length comments) ++ ")") ]
                , div [] (List.map (commentView currentTime) comments)
                ]


commentView : Posix -> Comment -> Html msg
commentView currentTime comment =
    div [ css [ padding2 (px 16) (px 0), borderBottom3 (px 1) solid theme.border ] ]
        [ rantViewHeader currentTime
            { userAvatar = comment.user_avatar
            , userUsername = comment.user_username
            , userScore = comment.user_score
            , createdTime = toPosix comment.created_time
            }
        , rantViewText comment.body
        ]


rantImageView : List (Attribute msg) -> Maybe AttachedImage -> Html msg
rantImageView attrs image =
    case image of
        Just { url } ->
            img (src url :: attrs) []

        Nothing ->
            span [] []
