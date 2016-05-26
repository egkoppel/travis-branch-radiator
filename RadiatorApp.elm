module RadiatorApp exposing (..)

import Html.App as Html
import Task exposing (Task)
import Time exposing (..)
import Radiator.Model as Model
import Radiator.View as View
import Radiator.Update as Update

defaultConfig = { apiKey = Nothing, repositories =
  ["elm-lang/elm-compiler", "elm-lang/core"] }


config: Maybe Model.Configuration -> Model.Configuration
config loadedConfig = Maybe.withDefault defaultConfig loadedConfig


initialConfigPanel: Model.Configuration -> Model.ConfigPanel
initialConfigPanel config =
  {
    repositorySlug = "",
    apiKeyValue = Maybe.withDefault "" config.apiKey
  }

main : Program { localStorageCfg: Maybe Model.Configuration }
main = 
  Html.programWithFlags { init = initialize, view = View.view, update = Update.update, subscriptions = \_ -> timedUpdate }

initialize : { localStorageCfg: Maybe Model.Configuration } -> (Model.Model, Cmd Model.Msg)
initialize { localStorageCfg } =
 let config = Maybe.withDefault defaultConfig localStorageCfg
     model = Model.Model Model.Config config (initialConfigPanel config) []
 in (model, Update.refreshBuilds config)
 

timedUpdate : Sub Model.Msg
timedUpdate = every (30 * second) (\_ -> Model.RefreshBuilds)
