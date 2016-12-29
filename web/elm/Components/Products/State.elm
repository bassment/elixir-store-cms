module Components.Products.State exposing (..)

type alias ProductId = Int

type alias Product = {
  id : ProductId,
  title : String,
  price : Int,
  image : String
}
