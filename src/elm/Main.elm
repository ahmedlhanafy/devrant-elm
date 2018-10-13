module Main exposing (..)

import Browser
import Browser.Navigation exposing (Key, replaceUrl, load)
import Url exposing (Url)
import Url.Parser exposing (Parser, (</>), int, map, oneOf, s, string, top)
import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, src)
import Http exposing (Error)
import Types exposing (..)
import Task
import HomePage.Main as HomePage
import RantPage.Main as RantPage
import Views.Theme exposing (theme)
import Time exposing (Posix, millisToPosix)


---- MODEL ----


type Route
    = HomeRoute
    | RantRoute Int
    | NotFoundRoute


toRoute : Url -> Route
toRoute url =
    Maybe.withDefault NotFoundRoute (Url.Parser.parse routeParser url)


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Url.Parser.map HomeRoute Url.Parser.top
        , Url.Parser.map RantRoute (Url.Parser.s "rant" </> Url.Parser.int)
        ]


type RouterModel
    = Home HomePage.Model
    | Rant RantPage.Model
    | NotFound


type alias Model =
    { routerModel : RouterModel, key : Key, url : Url, currentTime : Posix }


updateWith : (subModel -> RouterModel) -> (subMsg -> Msg) -> ( subModel, Cmd subMsg ) -> ( RouterModel, Cmd Msg )
updateWith toModel toMsg ( subModel, subCmd ) =
    ( toModel subModel
    , Cmd.map toMsg subCmd
    )


init : flags -> Url -> Key -> ( Model, Cmd Msg )
init flags url key =
    let
        route =
            toRoute url

        ( routerModel, cmd ) =
            case route of
                HomeRoute ->
                    updateWith Home HomePageMsg HomePage.init

                RantRoute id ->
                    updateWith Rant RantPageMsg (RantPage.init id)

                NotFoundRoute ->
                    ( NotFound, Cmd.none )
    in
        ( { routerModel = routerModel
          , url = url
          , key = key
          , currentTime = Time.millisToPosix 0
          }
        , Cmd.batch [ Task.perform SetTime Time.now, cmd ]
        )



---- UPDATE ----


type Msg
    = HomePageMsg HomePage.Msg
    | RantPageMsg RantPage.Msg
    | LinkClicked Browser.UrlRequest
    | UrlChanged Url
    | Tick Posix
    | SetTime Posix


toModelz : Model -> (subModel -> RouterModel) -> ( subModel, Cmd a ) -> ( Model, Cmd a )
toModelz model toModelzz ( routerModelz, cmd ) =
    ( { model | routerModel = (toModelzz routerModelz) }, cmd )


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

            ( HomePageMsg homeMsg, Home homeModel ) ->
                let
                    ( finalModel, cmd ) =
                        toModelz model Home (HomePage.update homeMsg homeModel)
                in
                    ( finalModel
                    , Cmd.map HomePageMsg cmd
                    )

            ( RantPageMsg rantMsg, Rant rantModel ) ->
                let
                    ( finalModel, cmd ) =
                        toModelz model Rant (RantPage.update rantMsg rantModel)
                in
                    ( finalModel
                    , Cmd.map RantPageMsg cmd
                    )

            -- ( RantPageMsg rantMsg, Rant rantModel ) ->
            --     RantPage.update rantMsg rantModel
            --         |> updateWith Rant RantPageMsg
            ( LinkClicked urlRequest, _ ) ->
                case urlRequest of
                    Browser.Internal url ->
                        ( model, replaceUrl model.key (Url.toString url) )

                    Browser.External href ->
                        ( model, load href )

            ( UrlChanged url, _ ) ->
                ( { model | url = url }
                , Cmd.none
                )

            ( _, _ ) ->
                -- Disregard messages that arrived for the wrong page.
                ( model, Cmd.none )



-- VIEW ----


type alias Document msg =
    { title : String
    , body : List (Html msg)
    }


toUnstyledDocument : Document msg -> Browser.Document msg
toUnstyledDocument doc =
    { title = doc.title
    , body = List.map toUnstyled doc.body
    }


view : Model -> Document Msg
view model =
    let
        mapView msg viewFunc =
            Html.Styled.map
                msg
                viewFunc

        routerModel =
            model.routerModel

        body =
            [ div
                [ css
                    [ displayFlex
                    , justifyContent center
                    , backgroundColor theme.bodyBackground
                    ]
                ]
                [ case routerModel of
                    Home homeModel ->
                        mapView HomePageMsg (HomePage.view homeModel model.currentTime)

                    Rant rantModel ->
                        mapView RantPageMsg (RantPage.view rantModel model.currentTime)

                    NotFound ->
                        span [] [ text "Not Found" ]
                ]
            ]
    in
        { title = "Hey", body = body }



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 60000 Tick


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
