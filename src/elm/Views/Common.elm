module Views.Common exposing (..)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, src)
import Html.Styled.Events exposing (onClick)
import Types exposing (..)
import Views.Theme exposing (theme)


tagView : String -> Html msg
tagView tagText =
    span
        [ css
            [ height (px 26)
            , padding2 (px 4) (px 8)
            , marginRight (px 8)
            , marginBottom (px 8)
            , backgroundColor (rgba 153 153 153 0.2)
            , color theme.secondaryText
            , fontSize (px 15)
            , displayFlex
            , justifyContent center
            , alignItems center
            , borderRadius (px 4)
            ]
        ]
        [ text tagText ]


avatarView : Maybe UserAvatar -> Html msg
avatarView image =
    img
        [ css
            [ width (px 36)
            , height (px 36)
            , borderRadius (px 6)
            ]
        , src
            (case image of
                Just img ->
                    "https://avatars.devrant.io/" ++ img.i

                Nothing ->
                    "https://avatars.devrant.io/v-20_c-3_b-1_g-m_9-1_1-1_16-1_3-2_8-1_7-1_5-1_12-1_6-2_10-1_2-14_22-1_4-1.jpg"
            )
        ]
        []


btn : List (Attribute msg) -> List (Html msg) -> Html msg
btn =
    styled button
        [ border (px 0)
        , margin (px 0)
        , padding (px 0)
        , overflow visible
        , backgroundColor transparent
        , color (rgb 255 255 255)
        , cursor pointer
        ]
