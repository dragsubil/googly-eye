port module Main exposing (..)

import Html exposing (..)
import Mouse
import Svg as S
import Svg.Attributes as SA
import Window
import Task


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { winWidth : Float
    , winHeight : Float
    , mouseX : Float
    , mouseY : Float
    }


type Msg
    = NoOp
    | WinSize Window.Size
    | MouseCoords Mouse.Position



-- INIT


init : ( Model, Cmd Msg )
init =
    ( Model 0 0 0 0, Task.attempt getWindowSize Window.size )


getWindowSize : Result x Window.Size -> Msg
getWindowSize result =
    case result of
        Ok winSize ->
            WinSize winSize

        Err _ ->
            NoOp



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        NoOp ->
            ( model, Cmd.none )

        WinSize size ->
            ( { model | winWidth = (toFloat size.width), winHeight = (toFloat size.height) }
            , Cmd.none
            )

        MouseCoords coords ->
            ( { model | mouseX = (toFloat coords.x), mouseY = (toFloat coords.y) }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.batch
        [ Window.resizes WinSize
        , Mouse.moves MouseCoords
        ]



-- VIEW


view : Model -> Html Msg
view model =
    let
        corneaX =
            model.winWidth / 2

        corneaY =
            model.winHeight / 2

        corneaRadius =
            175

        irisRadius =
            70

        slope =
            (model.mouseX - corneaX) / (model.mouseY - corneaY)

        corneaIrisGap =
            16

        irisY =
            if ((model.mouseX - corneaX) ^ 2 + (model.mouseY - corneaY) ^ 2) < (corneaRadius - corneaIrisGap - irisRadius) ^ 2 then
                model.mouseY
            else if model.mouseY > corneaY then
                (corneaY
                    + ((corneaRadius - irisRadius - corneaIrisGap)
                        / (sqrt ((slope * slope) + 1))
                      )
                )
            else
                (corneaY
                    - ((corneaRadius - irisRadius - corneaIrisGap)
                        / (sqrt ((slope * slope) + 1))
                      )
                )

        irisX =
            (slope * (irisY - corneaY)) + corneaX

        spotX =
            irisX + 25

        spotY =
            irisY - 18

        spotRadius =
            8
    in
        S.svg
            [ SA.width "100%", SA.height "100%" ]
            [ S.rect
                [ SA.width "100%", SA.height "100%", SA.fill "black" ]
                []
            , drawCircle corneaX corneaY corneaRadius "white"
            , drawCircle irisX irisY irisRadius "red"
            , drawCircle spotX spotY spotRadius "white"
            ]


drawCircle : Float -> Float -> Float -> String -> Html msg
drawCircle cx cy r fill =
    S.circle
        [ SA.cx (toString cx)
        , SA.cy (toString cy)
        , SA.r (toString r)
        , SA.fill fill
        ]
        []
