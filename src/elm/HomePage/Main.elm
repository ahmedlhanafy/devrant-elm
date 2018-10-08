module HomePage.Main exposing (Model, view, init, Msg, update)

import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, src)
import Html.Styled.Events exposing (onClick)
import Types exposing (Rant, GlobalState)
import HomePage.Decoder exposing (decodeRants)
import Views.RantView exposing (rantView)
import Views.Common exposing (btn)
import Http exposing (Error)
import String exposing (fromInt)
import Http exposing (send, Error)


-- API


getRants : Int -> Cmd Msg
getRants pageIndex =
    let
        limit =
            20

        url =
            "https://www.devrant.io/api/devrant/rants?app=3&sort=algo&limit=" ++ (fromInt limit) ++ "&skip=" ++ (fromInt (pageIndex * limit))
    in
        send SetRants (Http.get url decodeRants)



-- MODEL


type alias Model =
    { rants : List Rant
    , loading : Bool
    , loadingMore : Bool
    , pageIndex : Int
    }


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


view : Model -> GlobalState -> Html Msg
view model globalState =
    if model.loading then
        img [ src "/loading.svg" ] []
    else
        div []
            [ ul [ css [ maxWidth (px 600), flex (int 1), overflowY auto, margin (px 0), padding (px 0) ] ]
                (List.map (rantView globalState.currentTime) model.rants)
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
        btn
            [ css
                [ width (pct 100)
                , height (px 80)
                , fontSize (px 20)
                , margin2 (px 8) (px 0)
                , borderRadius (px 6)
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
            , onClick (LoadMore (model.pageIndex + 1))
            ]
            [ text "Load More" ]
