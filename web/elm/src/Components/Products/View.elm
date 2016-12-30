module Components.Products.View exposing (productsView)

import Products.ProductsCss exposing (..)
import SharedStyles exposing (..)

import Html exposing (..)
import Html.CssHelpers exposing (..)
import Html.Attributes exposing (..)

import Main.Actions exposing (Action(..))
import Components.Products.State exposing (Product)

{ id, class, classList } =
    productsNamespace


productsView :  Html Action
productsView  =
  div [ class [ "container" ] ]
    [
      text "Products"
      -- productsListView products
    ]


productsListView : List Product -> Html Action
productsListView products =
  div [] (List.map productItemView products)


productItemView : Product -> Html Action
productItemView product =
  div []
    [
      text (product.title ++ ": " ++ (toString product.price))
    ]
