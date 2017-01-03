module Components.Products exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onInput, onClick)
import Helpers.Class as Class


-- ENTRY POINT
-- main : Program Never ( State, Cmd Action ) Action
-- main =
--     Html.program
--         { init = init ! []
--         , update = update
--         , view = view
--         , subscriptions = subscriptions
--         }


subscriptions : State -> Sub Action
subscriptions state =
    Sub.map ProductsClasses Class.subscriptions



-- STATE
-- type alias ProductId = Int


type alias Product =
    { title : String
    , price : Int
    , image : String
    }


type alias State =
    { products : List Product
    , classes : Class.State
    , input : String
    }


init : ( State, Cmd Action )
init =
    ( State products Class.init ""
    , Cmd.batch
        [ Class.fetchClasses "./Products.css"
        ]
    )



-- ACTIONS AND UPDATE


type Action
    = ProductsClasses Class.Action
    | Input String
    | SendMessage String


type OutAction
    = Message String


update : Action -> State -> ( State, Cmd Action, Maybe OutAction )
update action state =
    case action of
        ProductsClasses subAction ->
            let
                ( classes, _ ) =
                    Class.update subAction state.classes
            in
                ( { state | classes = classes }, Cmd.none, Nothing )

        Input newInput ->
            ( { state | input = newInput }, Cmd.none, Nothing )

        SendMessage input ->
            ( { state | input = "" }, Cmd.none, Just <| Message input )



-- VIEW


view : State -> Html Action
view state =
    div [ class (Class.getClass "text" state.classes) ]
        [ text "Products"
        , productsListView products
        , viewChat state
        ]


productsListView : List Product -> Html Action
productsListView products =
    div [] (List.map productItemView products)


productItemView : Product -> Html Action
productItemView product =
    div []
        [ text (product.title ++ ": " ++ (toString product.price))
        ]


viewChat : State -> Html Action
viewChat state =
    div []
        [ input [ value state.input, onInput Input ] []
        , button
            [ onClick ( SendMessage state.input )
            ]
            [ text "Send" ]
        ]



-- PRODUCTS


products : List Product
products =
    [ Product "Cosy Table for a dinner" 120 "image:sample"
    , Product "Toy sports car for babies" 200 "image:sample"
    ]
