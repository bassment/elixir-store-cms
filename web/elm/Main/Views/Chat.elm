module Main.Views.Chat exposing (chatView)

import Html exposing (Html, div, input, text, button)
import Html.Events exposing (onInput, onClick)

import Main.Actions exposing (Action(..))
import Main.State exposing (State)

chatView : State -> Html Action
chatView state =
  div []
    [
      div [] (List.map messageView state.messages),
      input [ onInput Input ] [],
      button [ onClick SendMessage ] [text "Send"]
    ]


messageView : String -> Html Action
messageView msg =
  div [] [ text msg ]
