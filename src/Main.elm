port module Main exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode exposing (..)


port addMarker : Float -> Cmd msg


main : Program Never Model Msg
main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }



-- MODEL


type alias Model =
    { counter : Float
    }


type alias LatLong =
    { latitude : Float
    , longitude : Float
    }


init : ( Model, Cmd msg )
init =
    ( { counter = 0 }, Cmd.none )



-- UPDATE


type Msg
    = SetLatitude Float
    | SetLongitude Float
    | AddMarker


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        SetLatitude latitude ->
            model ! []

        SetLongitude longitude ->
            model ! []

        AddMarker ->
            let
                pos =
                    model.counter

                newMarker =
                    LatLong pos pos
            in
                ( { model | counter = model.counter + 1 }
                , addMarker model.counter
                )


googleMap : List (Attribute a) -> List (Html a) -> Html a
googleMap =
    Html.node "google-map"


marker : List (Attribute a) -> List (Html a) -> Html a
marker =
    Html.node "google-map-marker"


view : Model -> Html Msg
view model =
    div []
        [ button [ onClick AddMarker ] [ text "add marker" ]
        , googleMap
            [ attribute "api-key" "AIzaSyD3E1D9b-Z7ekrT3tbhl_dy8DCXuIuDDRc" ]
            []
        ]


onChange : (Float -> Msg) -> Attribute Msg
onChange toMsg =
    Decode.string
        |> Decode.andThen decodeLatLong
        |> Decode.at [ "target", "value" ]
        |> Decode.map toMsg
        |> on "change"


decodeLatLong : String -> Decoder Float
decodeLatLong str =
    case Decode.decodeString Decode.float str of
        Ok num ->
            Decode.succeed (num / 10000)

        Err err ->
            Decode.fail err
