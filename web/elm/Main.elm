module Main exposing (..)

import Html exposing (Html, div)
import Html.Attributes exposing (class)

import Components.Main.State exposing (State, init)
import Components.Main.Actions exposing (Action(..))
import Components.Main.Update exposing (update)
import Components.Main.View exposing (chatView)

import Phoenix.Socket as Socket
import Phoenix.Channel

main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- SUBSCRIPTIONS

subscriptions : State -> Sub Action
subscriptions state =
  Socket.listen state.phxSocket PhoenixMsg


-- VIEW

view : State -> Html Action
view state =
  div [ class "elm-app" ] [ chatView state ]
