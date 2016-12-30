module Components.Products.Update exposing (..)

import Components.Products.Actions exposing (Action(..))
import Components.Products.State exposing (Product)


update : Action -> List Product -> ( List Product, Cmd Msg )
update action products =
    case action of
        NoOp ->
            ( products, Cmd.none )
