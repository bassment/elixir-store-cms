module Components.Products.View exposing (productsView)

import Html exposing (Html, div, text)
import Main.Actions exposing (Action(..))

productsView: Html Action
productsView =
  div []
    [
      text "Products"
    ]
