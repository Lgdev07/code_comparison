defmodule CodeComparison.Structs.Language do
  @moduledoc false

  defstruct [:name, :code, :topic, :commiter_name, :commiter_url, :path]

  def build(%{name: name, code: code, topic: topic, path: path}) do
    %__MODULE__{
      name: name,
      code: code,
      topic: topic,
      path: path
    }
  end
end
