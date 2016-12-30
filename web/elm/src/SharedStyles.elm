module SharedStyles exposing (..)

import Html.CssHelpers exposing (withNamespace)


type CssClasses
    = NavLink


type CssIds
    = ReactiveLogo
    | BuyTickets


productsNamespace =
    withNamespace "products"
