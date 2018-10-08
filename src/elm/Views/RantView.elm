module Views.RantView exposing (rantView)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, src)
import Html.Styled.Events exposing (onClick)
import Types exposing (..)
import Time exposing (Posix, millisToPosix)
import Views.Common exposing (..)
import Views.Theme exposing (theme)
import Time.Distance as Distance
import String exposing (fromInt, toFloat)


rantView : Posix -> Rant -> Html msg
rantView currentTime rant =
    let
        createdTime =
            rant.created_time
                |> (*) 1000
                |> Basics.round
                |> millisToPosix
    in
        li
            [ css
                [ borderBottom3 (px 1) solid theme.border
                , displayFlex
                , flexDirection column
                , margin2 (px 0) (px 2)
                , padding (px 16)
                ]
            ]
            [ div
                [ css
                    [ displayFlex
                    , flexDirection row
                    , alignItems center
                    , marginBottom (px 16)
                    ]
                ]
                [ avatarView
                    rant.user_avatar
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
                        [ text rant.user_username
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
                            [ text <| fromInt <| rant.user_score ]
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
            , div
                [ css
                    [ displayFlex
                    , flexDirection row
                    , justifyContent center
                    , alignItems flexStart
                    , marginBottom (px 16)
                    ]
                ]
                [ span
                    [ css
                        [ color theme.primaryText
                        , fontSize (px 14)
                        , letterSpacing (px 0.2)
                        , flex (int 1)
                        ]
                    ]
                    [ text rant.text ]
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


rantImageView : List (Attribute msg) -> Maybe AttachedImage -> Html msg
rantImageView attrs image =
    case image of
        Just { url } ->
            img (src url :: attrs) []

        Nothing ->
            span [] []
