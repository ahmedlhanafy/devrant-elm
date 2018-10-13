module Main exposing (..)

import Browser
import Browser.Navigation exposing (Key, pushUrl, load)
import Css exposing (..)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, src, href)
import Html.Styled.Events exposing (onClick)
import Url.Builder as UrlBuilder
import Url exposing (Url)
import Task
import Time exposing (Posix, millisToPosix)
import Http exposing (Error)
import HomePage
import RantPage
import Views.Theme exposing (theme)
import Views.Common exposing (button)
import Router exposing (..)


---- MODEL ----


type alias Model =
    { routerModel : RouterModel
    , key : Key
    , url : Url
    , currentTime : Posix
    }


init : flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        route =
            toRoute url

        inititalModel =
            { url = url
            , key = key
            , currentTime = Time.millisToPosix 0
            , routerModel = NotFound
            }

        ( model, cmd ) =
            case route of
                HomeRoute ->
                    HomePage.init
                        |> updateWith Home HomePageMsg inititalModel

                RantRoute id ->
                    RantPage.init id
                        |> updateWith Rant RantPageMsg inititalModel

                NotFoundRoute ->
                    ( inititalModel, Cmd.none )
    in
        ( model, Cmd.batch [ Task.perform SetTime Time.now, cmd ] )



---- UPDATE ----


type Msg
    = HomePageMsg HomePage.Msg
    | RantPageMsg RantPage.Msg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | Tick Posix
    | SetTime Posix


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        routerModel =
            model.routerModel
    in
        case ( msg, routerModel ) of
            ( Tick newTime, _ ) ->
                ( { model | currentTime = newTime }, Cmd.none )

            ( SetTime newTime, _ ) ->
                ( { model | currentTime = newTime }, Cmd.none )

            ( LinkClicked urlRequest, _ ) ->
                case urlRequest of
                    Browser.Internal url ->
                        ( model, pushUrl model.key (Url.toString url) )

                    Browser.External href ->
                        ( model, load href )

            ( UrlChanged url, _ ) ->
                changeRoute url model

            ( HomePageMsg homeMsg, Home homeModel ) ->
                updateWith Home HomePageMsg model (HomePage.update homeMsg homeModel)

            ( RantPageMsg rantMsg, Rant rantModel ) ->
                updateWith Rant RantPageMsg model (RantPage.update rantMsg rantModel)

            ( _, _ ) ->
                -- Disregard messages that arrived for the wrong page.
                ( model, Cmd.none )



-- VIEW ----


view : Model -> Document Msg
view model =
    let
        mapView msg viewFunc =
            Html.Styled.map msg viewFunc

        body =
            [ div
                [ css
                    [ displayFlex
                    , justifyContent center
                    , backgroundColor theme.bodyBackground
                    , height (vh 100)
                    , overflowY hidden
                    ]
                ]
                [ div
                    [ css
                        [ flex (int 1)
                        , overflowY auto
                        , padding2 (px 0) (px 400)
                        ]
                    ]
                    [ case model.routerModel of
                        Home homeModel ->
                            mapView HomePageMsg (HomePage.view homeModel model.currentTime)

                        Rant rantModel ->
                            mapView RantPageMsg (RantPage.view rantModel model.currentTime)

                        NotFound ->
                            Views.Common.a
                                [ UrlBuilder.relative [ "/" ] [] |> href ]
                                [ text "Go back to the feed" ]
                    ]
                ]
            ]
    in
        { title = "Feed", body = body }



---- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 60000 Tick



-- PROGRAM


main : Program () Model Msg
main =
    Browser.application
        { view = view >> toUnstyledDocument
        , init = init
        , update = update
        , subscriptions = subscriptions
        , onUrlRequest = LinkClicked
        , onUrlChange = UrlChanged
        }



-- UTILS


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


toUnstyledDocument : Document msg -> Browser.Document msg
toUnstyledDocument doc =
    { title = doc.title
    , body = List.map toUnstyled doc.body
    }


updateWith : (subModel -> RouterModel) -> (subMsg -> Msg) -> Model -> ( subModel, Cmd subMsg ) -> ( Model, Cmd Msg )
updateWith toModel toMsg model ( subModel, subCmd ) =
    ( { model | routerModel = (toModel subModel) }
    , Cmd.map toMsg subCmd
    )


changeRoute : Url -> Model -> ( Model, Cmd Msg )
changeRoute url model =
    let
        route =
            toRoute url

        newModel =
            { model | url = url }
    in
        case route of
            HomeRoute ->
                updateWith Home HomePageMsg newModel HomePage.init

            RantRoute id ->
                updateWith Rant RantPageMsg newModel (RantPage.init id)

            NotFoundRoute ->
                ( model, Cmd.none )
