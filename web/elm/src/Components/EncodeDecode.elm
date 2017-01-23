import Html exposing (Html, text, div)
import Json.Decode as JD
import Json.Encode as JE


products : JE.Value
products =
    JE.list
        [ JE.object [ ( "title", JE.string "Product One" ), ( "price", JE.int 445 ) ]
        , JE.object [ ( "title", JE.string "Product Two" ), ( "price", JE.int 200 ) ]
        , JE.object [ ( "title", JE.string "Product Three" ), ( "price", JE.int 150 ) ]
        ]


numbers : JE.Value
numbers =
    JE.list
        [ JE.int 1
        , JE.int 2
        , JE.int 3
        ]


encodeValue : JE.Value -> String
encodeValue value =
    JE.encode 4 value


type alias Product =
    { title : String, price : Int }


product : JD.Decoder Product
product =
    JD.map2 Product
        (JD.field "title" JD.string)
        (JD.field "price" JD.int)


productList : JD.Decoder (List Product)
productList =
    JD.list product


decodeValue : JE.Value -> List Product
decodeValue value =
    case JD.decodeValue productList value of
        Ok result ->
            result

        Err error ->
            [ { title = error, price = 0 } ]


main : Html a
main =
    div []
        [ -- text (encodeValue products)
          text (toString (decodeValue products))
        ]
