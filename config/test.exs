use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :code_comparison, CodeComparisonWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# --------------------------#
# Github
# --------------------------#
config :tesla, CodeComparison.Integrations.Github,
  adapter: CodeComparison.Integrations.Github.ApiMock
