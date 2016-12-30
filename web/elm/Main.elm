module Main exposing (..)

import Html exposing (Html, div, a, text)
import Html.Attributes exposing (class, href)

import Main.State exposing (State, init)
import Main.Actions exposing (Action(..))
import Main.Update exposing (update)
import Main.View exposing (chatView)

import Phoenix.Socket as Socket
import Phoenix.Channel

import Routing exposing (..)
import Navigation


main =
  Navigation.program OnLocationChange {
    init = init,
    view = view,
    update = update,
    subscriptions = subscriptions
  }


-- SUBSCRIPTIONS

subscriptions : State -> Sub Action
subscriptions state =
  Socket.listen state.phxSocket PhoenixMsg


-- VIEW

view : State -> Html Action
view state =
  div [ class "elm-app" ] [ page state ]


page : State -> Html Action
page state =
  case state.route of
    HomeRoute ->
      linksView

    ProductsRoute ->
      productsView

    NotFoundRoute ->
      notFoundView


linksView : Html Action
linksView =
  div []
    [
      a [ href ("#products") ] [ text "Products" ],
      a [ href ("#chat") ] [ text "Chat" ]
    ]


productsView: Html Action
productsView =
  div []
    [
      text "Products"
    ]


notFoundView : Html Action
notFoundView =
  div []
    [ text "Not found" ]
