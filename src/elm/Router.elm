module Router exposing (..)

import HomePage
import RantPage
import Url.Parser exposing (Parser, (</>), map, oneOf, s, string, top)
import Url exposing (Url)


type Route
    = HomeRoute
    | RantRoute Int
    | NotFoundRoute


type RouterModel
    = Home HomePage.Model
    | Rant RantPage.Model
    | NotFound


toRoute : Url -> Route
toRoute url =
    Maybe.withDefault NotFoundRoute (Url.Parser.parse routeParser url)


routeParser : Parser (Route -> a) a
routeParser =
    oneOf
        [ Url.Parser.map HomeRoute Url.Parser.top
        , Url.Parser.map RantRoute (Url.Parser.s "rant" </> Url.Parser.int)
        ]
