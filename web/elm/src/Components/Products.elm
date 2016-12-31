module Products exposing (productsView)

import ProductsCss exposing (..)
import SharedStyles exposing (..)

import Html exposing (..)
import Html.CssHelpers exposing (..)
import Html.Attributes exposing (..)


-- STATE

type alias ProductId = Int

type alias Product =
  { id : ProductId
  , title : String
  , price : Int
  , image : String
  }


-- ACTIONS AND UPDATE

type Action
    = NoOp


update : Action -> List Product -> ( List Product, Cmd Action )
update action products =
    case action of
        NoOp ->
            ( products, Cmd.none )


-- VIEW

{ id, class, classList } =
    productsNamespace


productsView :  Html Action
productsView  =
  div [ class [ "container" ] ]
    [
      text "Products"
      -- productsListView products
    ]


productsListView : List Product -> Html Action
productsListView products =
  div [] (List.map productItemView products)


productItemView : Product -> Html Action
productItemView product =
  div []
    [
      text (product.title ++ ": " ++ (toString product.price))
    ]
