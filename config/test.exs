use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :suggestions, SuggestionsWeb.Endpoint,
  http: [port: 4001],
  server: false,
  data: "cities_canada-usa_sample.tsv"

# Print only warnings and errors during test
config :logger, level: :warn
