module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Helpers.ViewHelper exposing (toCapital)
import Routing exposing (..)
import Navigation exposing (Location)
import Components.Products as Products exposing (OutMsg(..))
import Helpers.Class as Class
import OutMessage


-- ENTRY POINT


main : Program Never Model Msg
main =
    Navigation.program OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Sub.map MainClasses Class.subscriptions
        , Sub.map ProductsMsg (Products.subscriptions model.productsModel)
        ]



-- MODEL


type alias Model =
    { productsModel : Products.Model
    , classes : Class.Model
    , route : Routing.Route
    }


init : Location -> ( Model, Cmd Msg )
init location =
    let
        ( productsModel, productsCmd ) =
            Products.init

        currentRoute =
            Routing.parseLocation location

        initialModel =
            Model productsModel Class.init currentRoute
    in
        ( initialModel
        , Cmd.batch
            [ Cmd.map ProductsMsg productsCmd
            , Class.fetchClasses "./Main.css"
            ]
        )



-- MESSAGES AND UPDATE


type Msg
    = ProductsMsg Products.Msg
    | MainClasses Class.Msg
    | OnLocationChange Location


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ProductsMsg subMsg ->
            Products.update subMsg model.productsModel
                |> OutMessage.mapComponent (\updatedModel -> { model | productsModel = updatedModel })
                |> OutMessage.mapCmd ProductsMsg
                |> OutMessage.evaluateMaybe interpretOutMsg Cmd.none

        MainClasses subMsg ->
            let
                ( classes, _ ) =
                    Class.update subMsg model.classes
            in
                ( { model | classes = classes }, Cmd.none )

        OnLocationChange location ->
            let
                newRoute =
                    parseLocation location
            in
                ( { model | route = newRoute }, Cmd.none )


interpretOutMsg : Products.OutMsg -> Model -> ( Model, Cmd Msg )
interpretOutMsg outMsg model =
    case outMsg of
        SendMessage newInput ->
            ( model, Cmd.none )



-- VIEW


view : Model -> Html Msg
view model =
    div [ class "elm-app" ] [ switchPage model ]


switchPage : Model -> Html Msg
switchPage model =
    case model.route of
        HomeRoute ->
            viewHomePage model

        NotFoundRoute ->
            viewNotFound


viewHomePage : Model -> Html Msg
viewHomePage model =
    div []
        [ viewNavigation
        , Html.map ProductsMsg (Products.view model.productsModel)
        ]


viewNotFound : Html Msg
viewNotFound =
    div []
        [ text "Not found" ]


viewNavigation : Html Msg
viewNavigation =
    div [] (List.map viewLink [ "home", "products" ])


viewLink : String -> Html Msg
viewLink link =
    a [ href ("#" ++ link) ] [ text (toCapital link ++ " ") ]
