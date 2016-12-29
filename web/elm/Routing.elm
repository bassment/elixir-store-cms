module Routing exposing (..)

import String
import Navigation exposing (Location)
import UrlParser exposing (..)
import Components.Products.State exposing (ProductId)

type Route
  = HomeRoute
  | ProductsRoute
  -- | ProductRoute ProductId
  | NotFoundRoute


matchers : Parser (Route -> a) a
matchers =
  oneOf
    [
      map HomeRoute (top),
      -- map ProductRoute (s "product" </> int),
      map ProductsRoute (s "products")
    ]


parseLocation : Location -> Route
parseLocation location =
    case (parseHash matchers location) of
        Just route ->
            route

        Nothing ->
            NotFoundRoute
