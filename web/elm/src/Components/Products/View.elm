module Components.Products.View exposing (productsView)

import Products.ProductsCss exposing (..)
import SharedStyles exposing (..)

import Html exposing (..)
import Html.CssHelpers exposing (..)
import Html.Attributes exposing (..)
import Main.Actions exposing (Action(..))

{ id, class, classList } =
    productsNamespace

productsView: Html Action
productsView =
  div []
    [
      img [ id ReactiveLogo, src "images/phoenix.png" ] []
    ]
