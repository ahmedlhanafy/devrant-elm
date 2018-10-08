module Main exposing (..)

import Browser
import Html
import Css exposing (..)
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, src)
import Http exposing (Error)
import Types exposing (..)
import Task
import Time exposing (Posix, millisToPosix)
import HomePage.Main as HomePage
import Views.Theme exposing (theme)


---- MODEL ----


type alias Model =
    { globalState : GlobalState
    , homePage : HomePage.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        ( homePageModel, homePageCmd ) =
            HomePage.init
    in
        ( { globalState = { currentTime = Time.millisToPosix 0 }, homePage = homePageModel }
        , Cmd.batch [ Task.perform SetTime Time.now, Cmd.map HomePageMsg homePageCmd ]
        )



---- UPDATE ----


type Msg
    = Tick Posix
    | SetTime Posix
    | HomePageMsg HomePage.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Tick newTime ->
            ( { model | globalState = { currentTime = newTime } }, Cmd.none )

        SetTime newTime ->
            ( { model | globalState = { currentTime = newTime } }, Cmd.none )

        HomePageMsg homeMsg ->
            let
                ( newModel, cmd ) =
                    HomePage.update homeMsg model.homePage
            in
                ( { model | homePage = newModel }, Cmd.map HomePageMsg cmd )



---- VIEW ----


view : Model -> Html Msg
view model =
    let
        mapView msg viewFunc =
            Html.Styled.map
                msg
                viewFunc

        homeView =
            HomePage.view model.homePage model.globalState
    in
        div [ css [ displayFlex, justifyContent center, backgroundColor theme.bodyBackground ] ]
            [ mapView HomePageMsg homeView
            ]



---- SUBSCRIPTIONS ----


subscriptions : Model -> Sub Msg
subscriptions model =
    Time.every 60000 Tick



---- PROGRAM ----


main : Program () Model Msg
main =
    Browser.element
        { view = view >> toUnstyled
        , init = \_ -> init
        , update = update
        , subscriptions = subscriptions
        }
