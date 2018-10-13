module Router exposing (..)

import Url.Parser exposing (Parser, (</>), map, oneOf, s, string, top)
import Url exposing (Url)


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


urlToTitle : Url -> String
urlToTitle url =
    case (toRoute url) of
        HomeRoute ->
            "Feed"

        RantRoute _ ->
            "Rant"

        NotFoundRoute ->
            "NotFound"
