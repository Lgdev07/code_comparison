defmodule CodeComparisonWeb.Router do
  use CodeComparisonWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CodeComparisonWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CodeComparisonWeb do
    pipe_through :browser

    live "/", HomeLive, :index
  end
end
