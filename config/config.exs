# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :suggestions, SuggestionsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xPIxVN7peBN6btfouzE9RwAm9b8BtIFZQ6Vvr71BCCNh2ItE189zH2L1ZdmOVxnF",
  render_errors: [view: SuggestionsWeb.ErrorView, accepts: ~w(json)],
  pubsub: [name: Suggestions.PubSub, adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:user_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
