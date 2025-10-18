module API.Episodes exposing
  ( all
  , getRecent
  , Episodes
  , Episode
  )

import Http
import Json.Decode exposing (Decoder, int, list, nullable, string, succeed)
import Json.Decode.Pipeline exposing (required)

getRecent :
  { onResponse : Result Http.Error Episodes -> msg
  }
  -> Cmd msg
getRecent options =
  Http.get
    { url = "/data/episodes.json"
    , expect = Http.expectJson options.onResponse decoder
    }

-- TODO: pagination
all :
  { onResponse : Result Http.Error Episodes -> msg
  }
  -> Cmd msg
all options =
  Http.get
    { url = "/data/episodes.json"
    , expect = Http.expectJson options.onResponse decoder
    }

type alias Episodes =
  { count : Int
  , next : Maybe String
  , previous : Maybe String
  , results : List Episode
  }

decoder : Decoder Episodes
decoder =
  succeed Episodes
    |> required "count" int
    |> required "next" (nullable string)
    |> required "previous" (nullable string)
    |> required "results" (list episodeDecoder)

{-| Episode is a subset of full version from API.Episode. -}
type alias Episode =
  { number: Int
  , slug: String
  , title: String
  , created_at: String
  }

episodeDecoder : Decoder Episode
episodeDecoder =
  succeed Episode
    |> required "number" int
    |> required "slug" string
    |> required "title" string
    |> required "created_at" string
