module Components.Products exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)


-- ENTRY POINT


main : Program Never State Action
main =
    Html.program
        { init = initialState ! []
        , update = update
        , view = view
        , subscriptions = subscriptions
        }


subscriptions : State -> Sub Action
subscriptions state =
    Sub.none



-- STATE
-- type alias ProductId = Int


type alias Product =
    { title : String
    , price : Int
    , image : String
    }


type alias State =
    { products : List Product
    }


initialState : State
initialState =
    { products = products
    }



-- ACTIONS AND UPDATE


type Action
    = NoOp


update : Action -> State -> ( State, Cmd Action )
update action state =
    case action of
        NoOp ->
            ( state, Cmd.none )



-- VIEW


view : State -> Html Action
view state =
    div [ class "container" ]
        [ text "Products"
        , productsListView products
        ]


productsListView : List Product -> Html Action
productsListView products =
    div [] (List.map productItemView products)


productItemView : Product -> Html Action
productItemView product =
    div []
        [ text (product.title ++ ": " ++ (toString product.price))
        ]



-- PRODUCTS


products : List Product
products =
    [ Product "Cosy Table for a dinner" 120 "image:sample"
    , Product "Toy sports car for babies" 200 "image:sample"
    ]
