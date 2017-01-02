port module Helpers.Class exposing (..)

import Dict exposing (Dict, union, empty, get)
import Json.Decode exposing (dict, string, Decoder, Value, decodeValue)


type Action
    = ReceiveClass State


type alias State =
    Dict String String


port fetchClasses : String -> Cmd msg


port receiveClasses : (Value -> msg) -> Sub msg


subscriptions : Sub Action
subscriptions =
    receiveClasses (\v -> ReceiveClass (getDecodedResult v))


decoder : Decoder State
decoder =
    dict string


getDecodedResult : Value -> State
getDecodedResult v =
    case decodeValue decoder v of
        Ok val ->
            val

        Err _ ->
            empty


update : Action -> State -> ( State, Cmd Action )
update message state =
    case message of
        ReceiveClass d ->
            ( union d state, Cmd.none )


getClass : String -> State -> String
getClass key dict =
    case get key dict of
        Just class ->
            class

        Nothing ->
            ""


init : State
init =
    empty
