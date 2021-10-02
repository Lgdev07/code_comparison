defmodule CodeComparison.Integrations.Github.ApiBehaviour do
  @moduledoc false

  @callback get_last_commit(String.t()) :: {:ok, any} | {:error, String.t()}
end
