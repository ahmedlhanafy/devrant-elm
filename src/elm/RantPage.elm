module RantPage exposing (Model, Msg, init, update, view)

import Css exposing (..)
import Decoder exposing (rantResponseDecoder)
import Html
import Html.Styled exposing (..)
import Html.Styled.Attributes exposing (css, class, src)
import Html.Styled.Events exposing (onClick)
import Http exposing (send, Error)
import Types exposing (Rant, Comment, RantResponse)
import Url.Builder as Url
import Views.RantView exposing (rantView)
import Time exposing (Posix)


-- MODEL


type alias Model =
    { rant : Maybe Rant
    , comments : List Comment
    , loading : Bool
    }


init : Int -> ( Model, Cmd Msg )
init id =
    ( { rant = Nothing
      , comments = []
      , loading = True
      }
    , getRant id
    )



-- UPDATE


type Msg
    = SetRant (Result Error RantResponse)
    | LoadRant Int


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LoadRant id ->
            ( { model | loading = True }, getRant id )

        SetRant (Ok rantResponse) ->
            ( { model | rant = Just rantResponse.rant, comments = rantResponse.comments }, Cmd.none )

        SetRant (Err _) ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Posix -> Html Msg
view model currentTime =
    case model.rant of
        Just rant ->
            rantView currentTime model.comments rant

        Nothing ->
            img [ src "/loading.svg" ] []



-- API


getRant : Int -> Cmd Msg
getRant id =
    let
        url =
            Url.crossOrigin "https://www.devrant.io/"
                [ "api"
                , "devrant"
                , "rants"
                , String.fromInt id
                ]
                [ Url.int "app" 3 ]
    in
        Http.send SetRant (Http.get url rantResponseDecoder)
