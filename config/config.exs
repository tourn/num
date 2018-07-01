# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :num,
  ecto_repos: [Num.Repo]

# Configures the endpoint
config :num, NumWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "qd3FV9Ap9rWWuBxFxXjuh3hCrGrOSnEbiv+iL5u2nRpXYShOEpxIPwmFZLF2RYQ/",
  render_errors: [view: NumWeb.ErrorView, accepts: ~w(html json)],
  pubsub: [name: Num.PubSub,
           adapter: Phoenix.PubSub.PG2]

config :num, NumWeb.Gettext,
 default_locale: System.get_env("LOCALE") || "en"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
