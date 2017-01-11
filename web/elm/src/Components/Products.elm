module Components.Products exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Helpers.Class as Class
import Phoenix.Socket
import Phoenix.Channel
import Json.Encode as JsEncode
import Json.Decode as JsDecode exposing (decodeString, decodeValue, at)


-- ENTRY POINT
-- main : Program Never ( Model, Cmd Msg ) Msg
-- main =
--     Html.program
--         { init = init ! []
--         , update = update
--         , view = view
--         , subscriptions = subscriptions
--         }


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Phoenix.Socket.listen model.phxSocket PhoenixMsg
        , Sub.map ProductsClasses Class.subscriptions
        ]



-- MODEL
-- type alias ProductId = Int


type alias Product =
    { title : String
    , price : Int
    , image : String
    }


type alias Model =
    { phxSocket : Phoenix.Socket.Socket Msg
    , products : List String
    , classes : Class.Model
    , input : String
    }


init : ( Model, Cmd Msg )
init =
    let
        channel =
            Phoenix.Channel.init "store:products"
                |> Phoenix.Channel.onJoin ReceiveProducts

        ( initSocket, phxCmd ) =
            Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
                |> Phoenix.Socket.withoutHeartbeat
                |> Phoenix.Socket.on "allProducts" "store:products" ReceiveProducts
                |> Phoenix.Socket.join channel
    in
        ( Model initSocket [] Class.init ""
        , Cmd.batch
            [ Class.fetchClasses "./Products.css"
            , Cmd.map PhoenixMsg phxCmd
            ]
        )



-- MESSAGES AND UPDATE


type Msg
    = ProductsClasses Class.Msg
    | Input String
    | SocketMessage String
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveProducts JsEncode.Value
    | HandleSendError JsEncode.Value


type OutMsg
    = SendMessage String


update : Msg -> Model -> ( Model, Cmd Msg, Maybe OutMsg )
update msg model =
    case msg of
        PhoenixMsg msg ->
            let
                ( phxSocket, phxCmd ) =
                    Phoenix.Socket.update msg model.phxSocket
            in
                ( { model | phxSocket = phxSocket }, Cmd.map PhoenixMsg phxCmd, Nothing )

        ProductsClasses subMsg ->
            let
                ( classes, _ ) =
                    Class.update subMsg model.classes
            in
                ( { model | classes = classes }, Cmd.none, Nothing )

        Input newInput ->
            ( { model | input = newInput }, Cmd.none, Nothing )

        SocketMessage input ->
            ( { model | input = "" }, Cmd.none, Just <| SendMessage input )

        ReceiveProducts raw ->
            let
                messageDecoder =
                    at [ "products" ] JsDecode.string

                somePayload =
                    JsDecode.decodeValue messageDecoder raw
            in
                case somePayload of
                    Ok payload ->
                        ( { model | products = payload :: model.products }, Cmd.none, Nothing )

                    Err error ->
                        ( model, Cmd.none, Nothing )

        HandleSendError _ ->
            let
                message =
                    "Failed to Send Message"
            in
                ( model, Cmd.none, Nothing )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class (Class.getClass "text" model.classes) ]
        [ text "Products"
        , productsListView model.products
        , viewChat model
        ]


productsListView : List String -> Html Msg
productsListView products =
    div [] (List.map productItemView products)


productItemView : String -> Html Msg
productItemView product =
    div []
        [ text (product)
        ]


viewChat : Model -> Html Msg
viewChat model =
    div []
        [ input [ value model.input, onInput Input ] []
        , button
            [ onClick (SocketMessage model.input)
            ]
            [ text "Send" ]
        ]
