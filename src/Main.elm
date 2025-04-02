module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Html
import Url
import Url.Parser exposing ((</>), Parser, int, oneOf, s, string)


main : Program () Model Msg
main =
    Browser.application
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        , onUrlChange = UrlChanged
        , onUrlRequest = LinkClicked
        }


type Route
    = Home
    | NotFound


parseRoute : Parser (Route -> a) a
parseRoute =
    oneOf
        [ Url.Parser.map Home Url.Parser.top
        ]


toRoute : Url.Url -> Route
toRoute url =
    Maybe.withDefault NotFound (Url.Parser.parse parseRoute url)


type alias Model =
    { key : Nav.Key
    , url : Url.Url
    , page : Route
    }


init : () -> Url.Url -> Nav.Key -> ( Model, Cmd Msg )
init flags url key =
    case toRoute url of
        Home ->
            ( Model key url Home, Cmd.none )

        NotFound ->
            ( Model key url NotFound, Cmd.none )



-- UPDATE


type Msg
    = LinkClicked Browser.UrlRequest
    | UrlChanged Url.Url


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        LinkClicked urlRequest ->
            case urlRequest of
                Browser.Internal url ->
                    ( model, Nav.pushUrl model.key (Url.toString url) )

                Browser.External href ->
                    ( model, Nav.load href )

        UrlChanged url ->
            ( { model | url = url }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view : Model -> Browser.Document Msg
view model =
    case model.page of
        Home ->
            { title = "Home - Sasse Hugo"
            , body =
                [ Element.layout [] <|
                    Element.column [ padding 20 ]
                        [ h1 "Sasse"
                        , text "This is Sasse, welcome!"
                        ]
                ]
            }

        NotFound ->
            { title = "Not Found - Sasse Hugo"
            , body =
                [ Element.layout [] <|
                    Element.column [ padding 20 ]
                        [ h1 "Not Found"
                        , text "The page you're looking for does not exist"
                        ]
                ]
            }


h1 : String -> Element msg
h1 text =
    Element.html <| Html.h1 [] [ Html.text text ]
