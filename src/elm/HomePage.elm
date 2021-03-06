module HomePage exposing (Model, view, init, Msg, update)

import Css exposing (..)
import Decoder exposing (rantsResponseDecoder)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, src)
import Html.Styled.Events exposing (onClick)
import Http exposing (send, Error)
import String exposing (fromInt)
import Time exposing (Posix, millisToPosix)
import Types exposing (Rant)
import Url.Builder as Url
import Views.Common exposing (button)
import Views.RantView exposing (rantView)


-- MODEL


type alias Model =
    { rants : List Rant
    , loading : Bool
    , loadingMore : Bool
    , pageIndex : Int
    }


init : ( Model, Cmd Msg )
init =
    ( { rants = []
      , loading = True
      , loadingMore = False
      , pageIndex = 0
      }
    , getRants 0
    )



-- UPDATE


type Msg
    = SetRants (Result Error (List Rant))
    | LoadMore Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SetRants (Ok rants) ->
            ( { model | rants = model.rants ++ rants, loading = False, loadingMore = False }, Cmd.none )

        SetRants (Err _) ->
            ( model, Cmd.none )

        LoadMore pageIndex ->
            ( { model | loadingMore = True, pageIndex = pageIndex }, getRants pageIndex )



--VIEW


view : Model -> Posix -> Html Msg
view model currentTime =
    if model.loading then
        img [ src "/loading.svg" ] []
    else
        div []
            [ ul
                [ css
                    [ listStyle none
                    , padding (px 0)
                    ]
                ]
                (List.map (rantView currentTime []) model.rants)
            , loadMoreView model
            ]


loadMoreView : Model -> Html Msg
loadMoreView model =
    if model.loadingMore then
        div
            [ css
                [ height (px 80)
                , width (pct 100)
                , displayFlex
                , justifyContent center
                , alignItems center
                ]
            ]
            [ img
                [ css
                    [ width (pct 100)
                    , height (pct 100)
                    ]
                , src "/loading.svg"
                ]
                []
            ]
    else
        Views.Common.button
            [ onClick (LoadMore (model.pageIndex + 1))
            ]
            [ text "Load More" ]



-- API


getRants : Int -> Cmd Msg
getRants pageIndex =
    let
        limit =
            20

        url =
            Url.crossOrigin "https://www.devrant.io"
                [ "api"
                , "devrant"
                , "rants"
                ]
                [ Url.int "app" 3
                , Url.string "sort" "algo"
                , Url.int "limit" 20
                , Url.int "skip" (pageIndex * limit)
                ]
    in
        Http.get url rantsResponseDecoder
            |> send SetRants
