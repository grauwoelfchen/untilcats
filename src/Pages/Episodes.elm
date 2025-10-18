module Pages.Episodes exposing (Model, Msg, page)

import Components.Navbar
import Html exposing (..)
import Html.Attributes exposing (..)
import Http
import Route.Path
import Page exposing (Page)
import View exposing (View)

import API
import API.Episodes exposing (Episode, Episodes)

page : Page Model Msg
page =
  Page.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

-- init

type alias Model =
  { episodes : API.Data Episodes
  }


init : ( Model, Cmd Msg )
init =
  ( { episodes = API.Loading }
  , API.Episodes.all
      { onResponse = APIResponded
      }
  )

-- update

type Msg
  = APIResponded (Result Http.Error Episodes)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    APIResponded (Ok episodes) ->
      ( { model | episodes = API.Success episodes }
      , Cmd.none
      )
    APIResponded (Err httpError) ->
      ( { model | episodes = API.Failure httpError }
      , Cmd.none
      )

-- subscriptions

subscriptions: Model -> Sub Msg
subscriptions _ =
  Sub.none

-- view

view : Model -> View Msg
view model =
  Components.Navbar.view
    { page =
      { title = "Untilcats"
      , body =
        [ div [ class "breadcrumb" ]
            [ span [ class "divider" ] [ text "/" ]
            , span [ class "item active" ] [ text "episodes" ]
            ]
        , h1 [] [ text "All episodes" ]
        , case model.episodes of
            API.Loading ->
              div [ class "loading" ] [ text "Loading..." ]
            API.Success episodes ->
              viewEpisodesList episodes
            API.Failure httpError ->
              div [] [ text (API.toMessage httpError) ]
        ]
      }
    }

viewEpisodesList : Episodes -> Html Msg
viewEpisodesList episodes =
  div [ class "episodes" ]
    [ p []
      [ text ( "Showing all "
          ++ (String.fromInt (List.length episodes.results))
          ++ " episodes"
        )
      ]
    , div []
      (List.indexedMap viewEpisode episodes.results)
    ]

viewEpisode : Int -> Episode -> Html Msg
viewEpisode _ episode =
  ul []
    [ li [] []
    , li []
      [ a [ Route.Path.href (
          Route.Path.Episodes_Slug_ { slug = episode.slug }) ]
        [ h2 [] [ text episode.title ] ]
      , span [ class "number" ]
          [ text ("#" ++ String.fromInt(episode.number)) ]
      , span [ class "date" ] [ text episode.created_at ]
      ]
    ]
