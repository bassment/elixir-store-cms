# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :baby_store,
  ecto_repos: [BabyStore.Repo]

# Configures the endpoint
config :baby_store, BabyStore.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "9l8KPxSA8ZwsyDkt4wbjmYPAJHBkAhl+rT5nKzYdQxk1TiTfS9RE8PSvFVz4rFEG",
  render_errors: [view: BabyStore.ErrorView, accepts: ~w(html json)],
  pubsub: [name: BabyStore.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Postgres pubsub
config :baby_store, TestListener,
  database: "baby_store_dev",
  username: "postgres",
  password: "",
  hostname: "localhost"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
