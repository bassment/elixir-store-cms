module Components.Main.Update exposing (update)

import Components.Main.State exposing (State)
import Components.Main.Actions exposing (Action(..))

import Json.Encode as JsEncode
import Json.Decode as JsDecode exposing (decodeString, decodeValue, at)

import Phoenix.Socket as ClientSocket
import Phoenix.Push
import Phoenix.Channel

update : Action -> State -> (State, Cmd Action)
update action state =
  case action of
    Input newInput ->
      ( { state | input = newInput }, Cmd.none)

    NewMessage str ->
      ({ state | messages = (str :: state.messages) }, Cmd.none)

    PhoenixMsg action ->
      let
        ( phxSocket, phxCmd ) = ClientSocket.update action state.phxSocket
      in
        ( { state | phxSocket = phxSocket }
        , Cmd.map PhoenixMsg phxCmd
        )

    SendMessage ->
      let
        payload =
          JsEncode.object
           [
            ("message", JsEncode.string state.input)
           ]
        phxPush =
          Phoenix.Push.init "shout" "room:lobby"
            |> Phoenix.Push.withPayload payload
            |> Phoenix.Push.onOk ReceiveMessage
            |> Phoenix.Push.onError HandleSendError
        (phxSocket, phxCmd) = ClientSocket.push phxPush state.phxSocket
      in
       (
        {
          state |
           phxSocket = phxSocket
        },
        Cmd.map PhoenixMsg phxCmd
       )


    ReceiveMessage raw ->
      let
        messageDecoder =
           at ["message"] JsDecode.string
        somePayload = JsDecode.decodeValue messageDecoder raw
      in
       case somePayload of
         Ok payload ->
           (
            { state | messages = payload :: state.messages },
            Cmd.none
           )
         Err error ->
           ( { state | messages = "Failed to receive message" :: state.messages }, Cmd.none )

    HandleSendError _ ->
      let
       message = "Failed to Send Message"
      in
       ({ state | messages = message :: state.messages }, Cmd.none)
