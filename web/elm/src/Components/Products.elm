module Components.Products exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Helpers.Class as Class
import Phoenix.Socket
import Phoenix.Channel
import Json.Encode as JE
import Json.Decode as JD


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
    , products : List Product
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
    | ReceiveProducts JE.Value
    | HandleSendError JE.Value


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
                productDecoder =
                    JD.map3 Product
                        (JD.field "title" JD.string)
                        (JD.field "price" JD.int)
                        (JD.field "image" JD.string)

                productListDecoder =
                    JD.list productDecoder

                payload =
                    JD.decodeValue productListDecoder raw
            in
                case payload of
                    Ok result ->
                        ( { model | products = result }, Cmd.none, Nothing )

                    Err error ->
                        ( { model | products = [Product error 0 ""] }, Cmd.none, Nothing )

        HandleSendError error ->
            ( model, Cmd.none, Nothing )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class (Class.getClass "text" model.classes) ]
        [ text "Products"
        , productsListView model.products
        , viewChat model
        ]


productsListView : List Product -> Html Msg
productsListView products =
    div [] (List.map productItemView products)


productItemView : Product -> Html Msg
productItemView product =
    div []
        [ text (toString product)
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
