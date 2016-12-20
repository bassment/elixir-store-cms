module Components.Main.View exposing (chatView)

import Html exposing (Html, div, input, text, button)
import Html.Events exposing (onInput, onClick)

import Components.Main.Actions exposing (Action(..))
import Components.Main.State exposing (State)

chatView : State -> Html Action
chatView state =
  div []
    [
      div [] (List.map viewMessage state.messages),
      input [onInput Input] [],
      button [onClick SendMessage] [text "Send"]
    ]

viewMessage : String -> Html msg
viewMessage msg =
  div [] [ text msg ]
