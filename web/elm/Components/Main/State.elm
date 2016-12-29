module Components.Main.State exposing (State, init)

import Components.Main.Actions exposing (Action(..))

import Phoenix.Socket
import Phoenix.Channel

import Routing
import Navigation exposing (Location)

type alias State = {
    route : Routing.Route,
    input : String,
    messages : List String,
    phxSocket : Phoenix.Socket.Socket Action
  }

initialState : Phoenix.Socket.Socket Action -> Routing.Route -> State
initialState initSocket route =
  { input = ""
  , messages = ["Test message"]
  , phxSocket = initSocket
  , route = route }


init : Location -> (State, Cmd Action)
init location =
  let
    currentRoute =
      Routing.parseLocation location

    channel =
      Phoenix.Channel.init "room:lobby"

    (initSocket, phxCmd) =
      Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
      |> Phoenix.Socket.withDebug
      |> Phoenix.Socket.on "shout" "room:lobby" ReceiveMessage
      |> Phoenix.Socket.join channel

  in
    (initialState initSocket currentRoute, Cmd.map PhoenixMsg phxCmd)
