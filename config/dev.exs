use Mix.Config

config :code_comparison, CodeComparisonWeb.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [
    node: [
      "node_modules/webpack/bin/webpack.js",
      "--mode",
      "development",
      "--watch",
      cd: Path.expand("../assets", __DIR__)
    ]
  ]

config :code_comparison, CodeComparisonWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/code_comparison_web/(live|views)/.*(ex)$",
      ~r"lib/code_comparison_web/templates/.*(eex)$"
    ]
  ]

config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
