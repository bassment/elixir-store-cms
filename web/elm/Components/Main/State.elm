module Components.Main.State exposing (State, init)

import Components.Main.Actions exposing (Action(..))

import Phoenix.Socket
import Phoenix.Channel

type alias State =
  { input : String
  , messages : List String
  , phxSocket : Phoenix.Socket.Socket Action
  }

init : (State, Cmd Action)
init =
  let
    channel =
    Phoenix.Channel.init "room:lobby"
    (initSocket, phxCmd) =
      Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
      |> Phoenix.Socket.withDebug
      |> Phoenix.Socket.on "shout" "room:lobby" ReceiveMessage
      |> Phoenix.Socket.join channel
    state =
      {
        input = "",
        messages = ["Test message"],
        phxSocket = initSocket
      }
  in
    (state , Cmd.map PhoenixMsg phxCmd)
