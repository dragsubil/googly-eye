module Main exposing (..)

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
    { irisCxPercent : Int, irisCyPercent : Int }


type Msg
    = Reset
    | MousePos Int Int



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model 50 50, Cmd.none )



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Reset ->
            ( model, Cmd.none )

        MousePos x y ->
            ( model, Cmd.none )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



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
        [ SA.cx (toPercent (toString model.irisCxPercent))
        , SA.cy (toPercent (toString model.irisCyPercent))
        , SA.r "70"
        , SA.fill "red"
        ]
        []


spot : Model -> Html msg
spot model =
    S.circle
        [ SA.cx (toPercent (toString (model.irisCxPercent + 3)))
        , SA.cy (toPercent (toString (model.irisCyPercent - 4)))
        , SA.r "8"
        , SA.fill "white"
        ]
        []


toPercent : String -> String
toPercent num =
    num ++ "%"
