module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Helpers.ViewHelper exposing (toCapital)
import Phoenix.Socket
import Phoenix.Push
import Phoenix.Channel
import Routing exposing (..)
import Navigation exposing (Location)
import Json.Encode as JsEncode
import Json.Decode as JsDecode exposing (decodeString, decodeValue, at)
import Components.Products as Products exposing (OutMsg(..))
import Helpers.Class as Class
import OutMessage


-- ENTRY POINT


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Phoenix.Socket.listen model.phxSocket PhoenixMsg
        , Sub.map MainClasses Class.subscriptions
        , Sub.map ProductsMsg (Products.subscriptions model.productsModel)
        ]



-- MODEL


type alias Model =
    { productsModel : Products.Model
    , route : Routing.Route
    , input : String
    , messages : List String
    , phxSocket : Phoenix.Socket.Socket Msg
    , classes : Class.Model
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( productsModel, productsCmd ) =
            Products.init

        currentRoute =
            Routing.parseLocation location

        channel =
            Phoenix.Channel.init "room:lobby"

        ( initSocket, phxCmd ) =
            Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
                |> Phoenix.Socket.withDebug
                |> Phoenix.Socket.on "shout" "room:lobby" ReceiveMessage
                |> Phoenix.Socket.join channel

        initialModel =
            Model productsModel currentRoute "" [ "Test message" ] initSocket Class.init
    in
        ( initialModel
        , Cmd.batch
            [ Cmd.map ProductsMsg productsCmd
            , Cmd.map PhoenixMsg phxCmd
            , Class.fetchClasses "./Main.css"
            ]
        )



-- MESSAGES AND UPDATE


type Msg
    = ProductsMsg Products.Msg
    | Input String
    | SendMessage String
    | NewMessage String
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveMessage JsEncode.Value
    | HandleSendError JsEncode.Value
    | OnLocationChange Location
    | MainClasses Class.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductsMsg subMsg ->
            Products.update subMsg model.productsModel
                |> OutMessage.mapComponent (\updatedModel -> { model | productsModel = updatedModel })
                |> OutMessage.mapCmd ProductsMsg
                |> OutMessage.evaluateMaybe interpretOutMsg Cmd.none

        MainClasses subMsg ->
            let
                ( classes, _ ) =
                    Class.update subMsg model.classes
            in
                ( { model | classes = classes }, Cmd.none )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )

        Input newInput ->
            ( { model | input = newInput }, Cmd.none )

        NewMessage str ->
            ( { model | messages = (str :: model.messages) }, Cmd.none )

        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )

        SendMessage input ->
            let
                payload =
                    JsEncode.object
                        [ ( "message", JsEncode.string input )
                        ]

                phxPush =
                    Phoenix.Push.init "shout" "room:lobby"
                        |> Phoenix.Push.withPayload payload
                        |> Phoenix.Push.onOk ReceiveMessage
                        |> Phoenix.Push.onError HandleSendError

                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.push phxPush model.phxSocket
            in
                ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd )

        ReceiveMessage raw ->
            let
                messageDecoder =
                    at [ "message" ] JsDecode.string

                somePayload =
                    JsDecode.decodeValue messageDecoder raw
            in
                case somePayload of
                    Ok payload ->
                        ( { model | messages = payload :: model.messages }, Cmd.none )

                    Err error ->
                        ( { model | messages = "Failed to receive message" :: model.messages }, Cmd.none )

        HandleSendError _ ->
            let
                message =
                    "Failed to Send Message"
            in
                ( { model | messages = message :: model.messages }, Cmd.none )


interpretOutMsg : Products.OutMsg -> Model -> ( Model, Cmd Msg )
interpretOutMsg outMsg model =
    case outMsg of
        ParentSendMessage newInput ->
            update (SendMessage newInput) model



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "elm-app" ] [ switchPage model ]


switchPage : Model -> Html Msg
switchPage model =
    case model.route of
        HomeRoute ->
            viewHomePage model

        ProductsRoute ->
            viewProductsPage model

        NotFoundRoute ->
            viewNotFound


viewHomePage : Model -> Html Msg
viewHomePage model =
    div []
        [ viewNavigation
        , viewChat model
        ]


viewProductsPage : Model -> Html Msg
viewProductsPage model =
    div []
        [ viewNavigation
        , Html.map ProductsMsg (Products.view model.productsModel)
        ]


viewNotFound : Html Msg
viewNotFound =
    div []
        [ text "Not found" ]


viewNavigation : Html Msg
viewNavigation =
    div [] (List.map viewLink [ "home", "products" ])


viewLink : String -> Html Msg
viewLink link =
    a [ href ("#" ++ link) ] [ text (toCapital link ++ " ") ]


viewChat : Model -> Html Msg
viewChat model =
    div []
        [ div [] (List.map viewMessage model.messages)
        , input [ value model.input, onInput Input ] []
        , button
            [ onClick (SendMessage model.input)
            ]
            [ text "Send" ]
        ]


viewMessage : String -> Html Msg
viewMessage msg =
    div []
        [ text msg
        ]
