module Main exposing (..)

import Browser
import String exposing (fromInt, toFloat)
import Html exposing (..)
import Html.Attributes exposing (src, class, value, style)
import Html.Events exposing (onClick)
import Http exposing (Error)
import Types exposing (..)
import API exposing (getRants)
import Msg exposing (..)
import Task
import Time exposing (Posix, millisToPosix)
import Time.Distance as Distance


---- MODEL ----


type alias Model =
    { rants : List Rant
    , loading : Bool
    , currentTime : Posix
    , loadingMore : Bool
    , pageIndex : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { rants = []
      , loading = True
      , currentTime = Time.millisToPosix 0
      , loadingMore = False
      , pageIndex = 0
      }
    , getRants 0
    )



---- UPDATE ----


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetRants (Ok rants) ->
            ( { model | rants = model.rants ++ rants, loading = False, loadingMore = False }, Cmd.none )

        SetRants (Err _) ->
            ( model, Cmd.none )

        Tick newTime ->
            ( { model | currentTime = newTime }, Cmd.none )

        LoadMore pageIndex ->
            ( { model | loadingMore = True, pageIndex = pageIndex }, getRants pageIndex )



---- VIEW ----


view : Model -> Html Msg
view model =
    div [ class "container" ]
        [ case model.loading of
            True ->
                img [ src "/loading.svg" ] []

            False ->
                div []
                    [ ul [ class "rows" ]
                        (List.map (rantView model.currentTime) model.rants)
                    , loadMoreView model
                    ]
        ]


loadMoreView : Model -> Html Msg
loadMoreView model =
    if model.loadingMore then
        div [ class "loading-more-container" ]
            [ img
                [ class ""
                , src "/loading.svg"
                ]
                []
            ]
    else
        button [ class "load-more-btn", onClick (LoadMore (model.pageIndex + 1)) ] [ text "Load More" ]


rantView : Posix -> Rant -> Html Msg
rantView currentTime rant =
    let
        createdTime =
            millisToPosix (round (rant.created_time * 1000))
    in
        li [ class "row" ]
            [ div [ class "user-container" ]
                [ avatar [ class "avatar" ] rant.user_avatar
                , div [ class "username-container" ]
                    [ span [ class "username" ] [ text rant.user_username, span [ class "badge" ] [ text (fromInt rant.user_score) ] ]
                    ]
                , span [ class "date" ] [ text (Distance.inWords currentTime createdTime) ]
                ]
            , div [ class "text-votes-container" ]
                [ span [ class "text" ] [ text rant.text ]
                ]
            , rantImage [ class "image" ] rant.attached_image
            , div [ class "tags" ] (List.map (\tag -> span [ class "tag" ] [ text tag ]) rant.tags)
            ]


avatar : List (Attribute msg) -> Maybe UserAvatar -> Html Msg
avatar attrs image =
    img
        [ class "avatar"
        , src
            (case image of
                Just img ->
                    "https://avatars.devrant.io/" ++ img.i

                Nothing ->
                    "src/assets/imgs/v-11_c-3_b-4_g-m_9-1_1-2_16-1_3-1_8-2_7-2_5-1_12-2_6-6_10-1_2-38_15-18_11-2_4-1.jpg"
            )
        ]
        []


rantImage : List (Attribute msg) -> Maybe AttachedImage -> Html Msg
rantImage attrs image =
    case image of
        Just { url } ->
            img [ src url, class "image" ] []

        Nothing ->
            span [] []



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 1000 Tick



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
