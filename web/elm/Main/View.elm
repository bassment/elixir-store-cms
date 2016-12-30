module Main.View exposing (view)

import Html exposing (Html, div, input, text, button, a)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onInput, onClick)

import Main.Actions exposing (Action(..))
import Main.State exposing (State)
import Components.Products.View exposing(productsView)

import Routing exposing (..)
import Helpers.ViewHelper exposing (toCapital)


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
      div [] (List.map viewLink ["home", "products"]),
      div [] (List.map viewMessage state.messages),
      input [ onInput Input ] [],
      button [ onClick SendMessage ] [text "Send"]
    ]


productsPageView : Html Action
productsPageView =
  div []
    [
      div [] (List.map viewLink ["home", "products"]),
      div [] [ productsView ]
    ]


viewLink : String -> Html Action
viewLink link =
      a [ href ("#" ++ link) ] [ text (toCapital link ++ " ") ]


viewMessage : String -> Html Action
viewMessage msg =
  div [] [ text msg ]


notFoundView : Html Action
notFoundView =
  div []
    [ text "Not found" ]
