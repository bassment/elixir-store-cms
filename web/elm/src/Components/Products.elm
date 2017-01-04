module Components.Products exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Helpers.Class as Class


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
    Sub.map ProductsClasses Class.subscriptions



-- MODEL
-- type alias ProductId = Int


type alias Product =
    { title : String
    , price : Int
    , image : String
    }


type alias Model =
    { products : List Product
    , classes : Class.Model
    , input : String
    }


init : ( Model, Cmd Msg )
init =
    ( Model products Class.init ""
    , Cmd.batch
        [ Class.fetchClasses "./Products.css"
        ]
    )



-- MESSAGES AND UPDATE


type Msg
    = ProductsClasses Class.Msg
    | Input String
    | SocketMessage String


type OutMsg
    = ParentSendMessage String


update : Msg -> Model -> ( Model, Cmd Msg, Maybe OutMsg )
update msg model =
    case msg of
        ProductsClasses subMsg ->
            let
                ( classes, _ ) =
                    Class.update subMsg model.classes
            in
                ( { model | classes = classes }, Cmd.none, Nothing )

        Input newInput ->
            ( { model | input = newInput }, Cmd.none, Nothing )

        SocketMessage input ->
            ( { model | input = "" }, Cmd.none, Just <| ParentSendMessage input )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class (Class.getClass "text" model.classes) ]
        [ text "Products"
        , productsListView products
        , viewChat model
        ]


productsListView : List Product -> Html Msg
productsListView products =
    div [] (List.map productItemView products)


productItemView : Product -> Html Msg
productItemView product =
    div []
        [ text (product.title ++ ": " ++ (toString product.price))
        ]


viewChat : Model -> Html Msg
viewChat model =
    div []
        [ input [ value model.input, onInput Input ] []
        , button
            [ onClick ( SocketMessage model.input )
            ]
            [ text "Send" ]
        ]



-- PRODUCTS


products : List Product
products =
    [ Product "Cosy Table for a dinner" 120 "image:sample"
    , Product "Toy sports car for babies" 200 "image:sample"
    ]
