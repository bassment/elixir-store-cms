module Routing exposing (..)

import Navigation exposing (Location)
import UrlParser exposing (..)


type Route
  = HomeRoute
  | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
  oneOf
    [
      map HomeRoute (top),
      map HomeRoute (s "home")
    ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
