use Mix.Config

config :code_comparison, CodeComparisonWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "W+CkxJR6nwpMksg1c0ikoNHWJ9487byRnYzQj7x9oSdta+w9Vu4e6AhCj1hyqqtP",
  render_errors: [view: CodeComparisonWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: CodeComparison.PubSub,
  live_view: [signing_salt: "5BkNzZjs"]

config :phoenix, :json_library, Jason

config :code_comparison, :github, token: System.get_env("GITHUB_TOKEN")

import_config "#{Mix.env()}.exs"
