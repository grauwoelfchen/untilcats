module Pages.Episodes.Slug_ exposing (Model, Msg, page)

import Components.Navbar
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Markdown
import Page exposing (Page)
import Route.Path
import View exposing (View)

import API
import API.Episode exposing (Episode)

page : { slug : String } -> Page Model Msg
page params =
  Page.element
  { init = init params
  , update = update
  , subscriptions = subscriptions
  , view = view params
  }

-- init

type alias Model =
  { episode : API.Data Episode
  }

init : { slug: String } -> ( Model, Cmd Msg )
init params =
  ( { episode = API.Loading }
  , API.Episode.get
      { slug = params.slug
      , onResponse = APIResponded
      }
  )

-- update

type Msg =
  APIResponded (Result Http.Error Episode)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    APIResponded (Ok episode) ->
      ( { model | episode = API.Success episode }
      , Cmd.none
      )
    APIResponded (Err httpError) ->
      ( { model | episode = API.Failure httpError }
      , Cmd.none
      )

subscriptions : Model -> Sub Msg
subscriptions _ =
  Sub.none

view : { slug: String } -> Model -> View Msg
view params model =
  Components.Navbar.view
    { page =
      { title = params.slug ++ " - Untilcats"
      , body =
        [ div [ class "breadcrumb" ]
            [ span [ class "divider" ] [ text "/" ]
            , a [ Route.Path.href Route.Path.Episodes, class "item" ]
                [ text "episodes" ]
            , span [ class "divider" ] [ text "/" ]
            , span [ class "item active" ] [ text params.slug ]
            ]
        , case model.episode of
            API.Loading ->
              div [ class "loading" ] [ text "Loading..." ]
            API.Success episode ->
              viewEpisode episode
            API.Failure httpError ->
              div [] [ text (API.toMessage httpError) ]
        ]
      }
    }

viewEpisode : Episode -> Html msg
viewEpisode episode =
  div [ class "episode" ]
    [ div []
      [ h1 [] [ text episode.title ]
      , span [ class "number" ]
          [ text ("#" ++ String.fromInt(episode.number)) ]
      , span [ class "date" ] [ text episode.created_at ]
      ]
    , ul [ class "tags" ]
        (List.map
          (\tag -> li []
            [ span [ class "tag" ] [ text tag ] ])
          episode.tags
        )
    , div []
        [ div [ class "description" ] [ toHtml episode.description ]
        , div [ class "screencast" ] [
            h3 [] [ text "Screencast" ]
          , video [ class "video", controls True ]
              [ source [ src ("/video/" ++ episode.slug ++ "-"
                ++ String.replace "-" "" episode.created_at ++ ".mp4") ] []
              ]
          ]
        , div [ class "text" ]
            [ h3 [] [ text "Note" ]
            , toHtml episode.note
            ]
        ]
      ]

toHtml : String -> Html msg
toHtml s =
  -- TODO: sanitize = True
  Markdown.toHtmlWith
    { defaultHighlighting = Just "text"
    , sanitize = False
    , githubFlavored = Just { tables = True, breaks = False }
    , smartypants = False
    } [] s
