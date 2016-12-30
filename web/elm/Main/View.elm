module Main.View exposing (view)

import Html exposing (Html, div, text)
import Html.Attributes exposing (class)

import Main.Actions exposing (Action(..))
import Main.State exposing (State)
import Main.Views.Navigation exposing (navigationView)
import Main.Views.Chat exposing (chatView)

import Components.Products.View exposing (productsView)

import Routing exposing (..)


view : State -> Html Action
view state =
  div [ class "elm-app" ] [ page state ]


page : State -> Html Action
page state =
  case state.route of
    HomeRoute ->
      homePageView state

    ProductsRoute ->
      productsPageView

    NotFoundRoute ->
      notFoundView


homePageView : State -> Html Action
homePageView state =
  div []
    [
      navigationView,
      chatView state
    ]


productsPageView : Html Action
productsPageView =
  div []
    [
      navigationView,
      productsView
    ]


notFoundView : Html Action
notFoundView =
  div []
    [ text "Not found" ]
