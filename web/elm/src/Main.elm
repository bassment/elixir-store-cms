module Main exposing (..)

import Html exposing (Html, div, a, text, input, button)
import Html.Attributes exposing (class, href)
import Html.Events exposing (onInput, onClick)

import Helpers.ViewHelper exposing (toCapital)

import Phoenix.Socket
import Phoenix.Push
import Phoenix.Channel

import Routing exposing (..)
import Navigation exposing (Location)

import Json.Encode as JsEncode
import Json.Decode as JsDecode exposing (decodeString, decodeValue, at)

import Products exposing (productsView)


-- ENTRY POINT

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
  Phoenix.Socket.listen state.phxSocket PhoenixMsg


-- STATE

type alias State =
  { route : Routing.Route
  , input : String
  , messages : List String
  , phxSocket : Phoenix.Socket.Socket Action
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


-- ACTIONS AND UPDATE

type Action
  = Input String
  | SendMessage
  | NewMessage String
  | PhoenixMsg (Phoenix.Socket.Msg Action)
  | ReceiveMessage JsEncode.Value
  | HandleSendError JsEncode.Value
  | OnLocationChange Location


update : Action -> State -> (State, Cmd Action)
update action state =
  case action of
    OnLocationChange location ->
            let
              newRoute =
                parseLocation location
            in
              ( { state | route = newRoute }, Cmd.none )

    Input newInput ->
      ( { state | input = newInput }, Cmd.none)

    NewMessage str ->
      ({ state | messages = (str :: state.messages) }, Cmd.none)

    PhoenixMsg action ->
      let
        ( phxSocket, phxCmd ) = Phoenix.Socket.update action state.phxSocket
      in
        ( { state | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )

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
        (phxSocket, phxCmd) = Phoenix.Socket.push phxPush state.phxSocket
      in
       ( { state | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )

    ReceiveMessage raw ->
      let
        messageDecoder =
           at ["message"] JsDecode.string
        somePayload = JsDecode.decodeValue messageDecoder raw
      in
       case somePayload of
         Ok payload ->
           ( { state | messages = payload :: state.messages }, Cmd.none )
         Err error ->
           ( { state | messages = "Failed to receive message" :: state.messages }, Cmd.none )

    HandleSendError _ ->
      let
       message = "Failed to Send Message"
      in
       ({ state | messages = message :: state.messages }, Cmd.none)


-- VIEW

view : State -> Html Action
view state =
  div [ class "elm-app" ] [ switchPage state ]


switchPage : State -> Html Action
switchPage state =
  case state.route of
    HomeRoute ->
      viewHomePage state

    ProductsRoute ->
      viewProductsPage

    NotFoundRoute ->
      viewNotFound


viewHomePage : State -> Html Action
viewHomePage state =
  div []
    [
      viewNavigation,
      viewChat state
    ]


viewProductsPage : Html Action
viewProductsPage =
  div []
    [
      viewNavigation
      -- productsView
    ]


viewNotFound : Html Action
viewNotFound =
  div []
    [ text "Not found" ]


viewNavigation : Html Action
viewNavigation =
  div [] (List.map viewLink ["home", "products"])


viewLink : String -> Html Action
viewLink link =
  a [ href ("#" ++ link) ] [ text (toCapital link ++ " ") ]


viewChat : State -> Html Action
viewChat state =
  div []
    [
      div [] (List.map viewMessage state.messages),
      input [ onInput Input ] [],
      button [ onClick SendMessage ] [text "Send"]
    ]


viewMessage : String -> Html Action
viewMessage msg =
  div [] [ text msg ]