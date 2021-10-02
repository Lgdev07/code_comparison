defmodule CodeComparison.Integrations.Github do
  @moduledoc false

  use Tesla

  @behaviour CodeComparison.Integrations.Github.ApiBehaviour

  plug Tesla.Middleware.BaseUrl, "https://api.github.com/"

  plug Tesla.Middleware.Headers, [
    {"user-agent", "codecomparison"},
    {"Authorization", "token #{token()}"}
  ]

  plug Tesla.Middleware.JSON

  defp token, do: Application.get_env(:code_comparison, :github)[:token]

  @spec get_last_commit(String.t()) :: {:ok, any} | {:error, String.t()}
  def get_last_commit(path) do
    get("repos/Lgdev07/code_comparison/commits?path=#{path}")
    |> handle_get()
  end

  defp handle_get({:ok, %Tesla.Env{status: 200, body: body}}), do: {:ok, body}
  defp handle_get({:error, _reason} = error), do: error
end
