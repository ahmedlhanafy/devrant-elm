module Views.Common exposing (..)

import Html
import Css exposing (..)
import Html.Styled as Styled
import Html.Styled.Attributes exposing (css, class, src)
import Html.Styled.Events exposing (onClick)
import Types exposing (..)
import Views.Theme exposing (theme)
import Url exposing (Url)
import Router exposing (..)


tagView : String -> Styled.Html msg
tagView tagText =
    Styled.span
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
        [ Styled.text tagText ]


avatarView : Maybe UserAvatar -> Styled.Html msg
avatarView image =
    Styled.img
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


btnStyles =
    [ width (pct 100)
    , height (px 80)
    , fontSize (px 20)
    , margin2 (px 8) (px 0)
    , borderRadius (px 6)
    , border (px 0)
    , margin (px 0)
    , padding (px 0)
    , overflow visible
    , backgroundColor transparent
    , color (rgb 255 255 255)
    , cursor pointer
    , displayFlex
    , justifyContent center
    , alignItems center
    , textDecoration none
    , [ hover, focus, active ]
        |> List.map
            (\func ->
                func
                    [ backgroundColor (rgba 255 255 255 0.2)
                    , border (px 0)
                    ]
            )
        |> Css.batch
    ]


topBar : msg -> Url -> Styled.Html msg
topBar msg url =
    let
        ( showBackBtn, title ) =
            case (toRoute url) of
                HomeRoute ->
                    ( False, "Feed" )

                RantRoute _ ->
                    ( True, "Rant" )

                NotFoundRoute ->
                    ( True, "NotFound" )
    in
        Styled.div
            ([ css
                [ backgroundColor theme.bodyBackground
                , height (px 54)
                , borderBottom3 (px 1) solid theme.border
                , displayFlex
                , alignItems center
                , justifyContent center
                , padding (px 6)
                , position fixed
                , top (px 0)
                , left (px 0)
                , right (px 0)
                , property "-webkit-app-region" "drag"
                ]
             ]
            )
            [ if showBackBtn then
                Styled.img
                    [ src "/back_icon.png"
                    , css
                        [ height (px 24)
                        , width (px 24)
                        , position absolute
                        , left (px 16)
                        , cursor pointer
                        ]
                    , onClick msg
                    ]
                    []
              else
                Styled.span [] []
            , Styled.span
                [ css
                    [ color theme.primaryText
                    , fontSize (px 20)
                    , fontWeight bold
                    ]
                ]
                [ Styled.text title ]
            ]



--     background-color: $content-background;
--     transition: background-color 200ms ease-in-out;
--
--     height: 64px;
--     min-height: 64px;
--     border-bottom: 1px $border solid;
--     display: flex;
--     flex-direction: row;
--     justify-content: flex-end;
--     align-items: center;
--     padding: 6px;
--     position: fixed;
--     top: 0;
--     left: $sidebar-width;
--     right: 0;
--     .avatar {
--         width: 28px;
--         height: 28px;
--         border-radius: 6px;
--         margin-right: 16px;
--     }
--     .icon {
--         color: $primary-text;
--         font-size: 30px;
--         margin: 0px 16px;
--     }
--     .title-wrapper {
--         display: flex;
--         flex: 1;
--         align-items: center;
--         justify-content: center;
--         .title {
--             color: $primary-text;
--             font-size: 18px;
--         }
--     }
-- }


button : List (Styled.Attribute msg) -> List (Styled.Html msg) -> Styled.Html msg
button =
    Styled.styled Styled.button btnStyles


a : List (Styled.Attribute msg) -> List (Styled.Html msg) -> Styled.Html msg
a =
    Styled.styled Styled.a btnStyles
