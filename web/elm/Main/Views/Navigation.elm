module Main.Views.Navigation exposing (navigationView)

import Html exposing (Html, div, text, a)
import Html.Attributes exposing (href)

import Main.Actions exposing (Action(..))
import Helpers.ViewHelper exposing (toCapital)

navigationView : Html Action
navigationView =
  div [] (List.map linkView ["home", "products"])


linkView : String -> Html Action
linkView link =
  a [ href ("#" ++ link) ] [ text (toCapital link ++ " ") ]
