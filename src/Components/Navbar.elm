module Components.Navbar exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Route.Path
import View exposing (View)

view : { page : View msg } -> View msg
view { page } =
  { title = page.title
  , body =
    [ div [ class "grid" ]
      [ div [ class "row" ]
        [ div [ class "column-10 offset-3 column-v-14 offset-v-1 column-l-16 column-m-16 column-s-16 column-t-16" ]
          [ header [ class "nav" ]
            [ a [ Route.Path.href Route.Path.Home_
                , class "title"
                ]
                [
                  img [ src "/assets/img/logo.png", class "logo", width 48 ] []
                , span [ class "text" ] [ text "Untilcats" ]
                ]
            , a [ Route.Path.href Route.Path.Episodes ]
                [ text "Episodes" ]
            , a [ Route.Path.href Route.Path.About ]
                [ text "About" ]
            ]
          ]
        ]
      , div [ class "row" ]
          [ div [ class "column-10 offset-3 column-v-14 offset-v-1 column-l-16 column-m-16 column-s-16 offset-t-16" ]
            [ div [ class "page" ]
              page.body
            ]
          ]
      ]
    ]
  }
