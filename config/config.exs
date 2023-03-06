# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :real_world, RealWorldWeb.Auth,
  issuer: :real_world,
  secret_key: "LWjqk1Xzw5qYUhbdwq4eZWl/bN4CB+ueiD2Aat0VPTR4HpwDJTaE3YUK1XSOJLOf"

config :real_world, RealWorldWeb.Auth.Pipeline,
  module: RealWorldWeb.Auth,
  error_handler: RealWorldWeb.Auth.ErrorHandler

config :real_world,
  ecto_repos: [RealWorld.Repo]

# Configures the endpoint
config :real_world, RealWorldWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: RealWorldWeb.ErrorView, accepts: ~w(json), layout: false],
  pubsub_server: RealWorld.PubSub,
  live_view: [signing_salt: "falpKlHq"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
