port module Main exposing (..)

import Html exposing (..)
import Svg as S
import Svg.Attributes as SA


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { winWidth : Int
    , winHeight : Int
    , mouseX : Int
    , mouseY : Int
    }


type Msg
    = Reset
    | ReceiveDataFromJS Model



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model 0 0 0 0, Cmd.none )



-- UPDATE


port receiveSizeAndPos : (Model -> msg) -> Sub msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( model, Cmd.none )

        ReceiveDataFromJS data ->
            ( data, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    receiveSizeAndPos ReceiveDataFromJS



-- VIEW


view : Model -> Html Msg
view model =
    S.svg
        [ SA.width "100%", SA.height "100%" ]
        [ S.rect
            [ SA.width "100%", SA.height "100%", SA.fill "black" ]
            []
        , cornea
        , iris model
        , spot model
        ]


cornea : Html Msg
cornea =
    S.circle
        [ SA.cx "50%", SA.cy "50%", SA.r "175", SA.fill "white" ]
        []


iris : Model -> Html msg
iris model =
    S.circle
        [ SA.cx (toString (model.winWidth / 2))
        , SA.cy (toString (model.winHeight / 2))
        , SA.r "70"
        , SA.fill "red"
        ]
        []


spot : Model -> Html msg
spot model =
    S.circle
        [ SA.cx (toString (model.winWidth / 2) + 5))
        , SA.cy (toString (model.winWidth / 2) - 4))
        , SA.r "8"
        , SA.fill "white"
        ]
        []
