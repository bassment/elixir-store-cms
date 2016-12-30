module Main exposing (..)

import Html exposing (Html, div, a, text)
import Html.Attributes exposing (class, href)

import Main.State exposing (State, init)
import Main.Actions exposing (Action(..))
import Main.Update exposing (update)
import Main.View exposing (view)

import Phoenix.Socket as Socket
import Phoenix.Channel

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
