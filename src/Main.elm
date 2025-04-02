module Main exposing (main)

import Browser
import Browser.Navigation as Nav
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region
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
            viewPage "Sasse" <|
                defaultParagraphs
                    []
                    [ defaultParagraph
                        [ text "This is Sasse, welcome!"
                        ]
                    ]

        NotFound ->
            viewPage "Not Found" (text "The page you're looking for does not exist")


viewPage : String -> Element msg -> Browser.Document msg
viewPage header content =
    { title = defaultTitle header
    , body =
        [ Element.layout [] <|
            Element.column [ padding 20, spacing 20 ]
                [ h1AndContent header content ]
        ]
    }


defaultTitle : String -> String
defaultTitle title =
    title ++ " - Sasse Hugo"


defaultParagraphs : List (Element.Attribute msg) -> List (Element msg) -> Element msg
defaultParagraphs attr paragraphs =
    Element.column ([ spacing 20 ] ++ attr) paragraphs


defaultParagraph : List (Element msg) -> Element msg
defaultParagraph elements =
    column [ spacing 6 ] elements


h1 : String -> Element msg
h1 text =
    Element.el [ Element.Region.heading 1, Font.size 32, Font.bold ] <| Element.text text


h1AndContent : String -> Element msg -> Element msg
h1AndContent h1Text content =
    column [ spacing 6 ] [ h1 h1Text, content ]
