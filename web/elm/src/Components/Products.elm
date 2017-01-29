module Components.Products exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
-- import Html.Effects exposing (onClick)
import Helpers.Class as Class
import Phoenix.Socket
import Phoenix.Push
import Phoenix.Channel
import Json.Encode as JE
import Json.Decode as JD


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Phoenix.Socket.listen model.phxSocket PhoenixMsg
        , Sub.map ProductsClasses Class.subscriptions
        ]



-- MODEL


type alias ProductId = Int


type alias Product =
    { id : ProductId
    , title : String
    , price : Int
    , image : String
    }


type alias Model =
    { phxSocket : Phoenix.Socket.Socket Msg
    , products : List Product
    , classes : Class.Model
    }


init : ( Model, Cmd Msg )
init =
    let
        channel =
            Phoenix.Channel.init "store:products"
                |> Phoenix.Channel.onJoin SuccessfulConnect

        ( initSocket, phxCmd ) =
            Phoenix.Socket.init "ws://localhost:4000/socket/websocket"
                |> Phoenix.Socket.on "products" "store:products" ReceiveProducts
                |> Phoenix.Socket.join channel

        requestProducts =
            Phoenix.Push.init "products" "store:products"

        ( phxSocket, pushCmd ) =
            Phoenix.Socket.push requestProducts initSocket
    in
        ( Model initSocket [] Class.init
        , Cmd.batch
            [ Class.fetchClasses "./Products.css"
            , Cmd.map PhoenixMsg pushCmd
            , Cmd.map PhoenixMsg phxCmd
            ]
        )



-- MESSAGES AND UPDATE


type Msg
    = ProductsClasses Class.Msg
    | SocketMessage String
    | PhoenixMsg (Phoenix.Socket.Msg Msg)
    | ReceiveProducts JE.Value
    | HandleSendError JE.Value
    | SuccessfulConnect JE.Value


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

        SocketMessage input ->
            ( model, Cmd.none, Just <| SendMessage input )

        ReceiveProducts raw ->
            let
                productDecoder =
                    JD.map4 Product
                        (JD.field "id" JD.int)
                        (JD.field "title" JD.string)
                        (JD.field "price" JD.int)
                        (JD.field "image" JD.string)

                productListDecoder =
                    JD.field "products" (JD.list productDecoder)

                payload =
                    JD.decodeValue productListDecoder raw
            in
                case payload of
                    Ok result ->
                        ( { model | products = result }, Cmd.none, Nothing )

                    Err error ->
                        ( { model | products = [ Product 1 error 0 "" ] }, Cmd.none, Nothing )

        SuccessfulConnect message ->
            ( model, Cmd.none, Nothing )

        HandleSendError error ->
            ( model, Cmd.none, Nothing )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class (Class.getClass "section" model.classes) ]
        [ div [ class "container mx-auto" ]
            [ h2 [] [ text "Products" ]
            , div [ class (Class.getClass "separator" model.classes) ] []
            , productsListView model
            ]
        ]


productsListView : Model -> Html Msg
productsListView model =
    div [ class "flex flex-wrap justify-around" ]
        (List.map (\product -> productItemView product model) model.products)


productItemView : Product -> Model -> Html Msg
productItemView product model =
    div [ class "xs-col-12 sm-col-5 lg-col-3 bg-white my2 mx1" ]
        [ div [ class "px2 py2" ]
            [ div [ class ("relative " ++ (Class.getClass "image-wrapper" model.classes)) ]
                [ img [ src ("assets/images/" ++ product.image) ] []
                , div [ class (Class.getClass "mask" model.classes) ]
                    [ a [ class "btn btn-outline white", href "#/products" ] [ text "Edit" ] ]
                ]
            , div [ class "flex py2" ]
                [ span [ class "flex-auto italic bold" ] [ text product.title ]
                , button [ class "btn circle bg-red" ]
                    [ i [ class "fa fa-trash" ] [] ]
                ]
            ]
        ]
