module Components.Main.Actions exposing (..)

import Phoenix.Socket as Socket
import Json.Encode as JsEncode

type Action
  = Input String
  | SendMessage
  | NewMessage String
  | PhoenixMsg (Socket.Msg Action)
  | ReceiveMessage JsEncode.Value
  | HandleSendError JsEncode.Value
