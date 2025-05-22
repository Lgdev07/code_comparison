defmodule CodeComparison.Topics do
  @moduledoc false
  @behaviour CodeComparison.Topics.Behaviour

  @spec get_topics :: list
  def get_topics do
    # Use the topics directory at the project root
    topics_dir = Path.expand("topics", File.cwd!())

    case File.ls(topics_dir) do
      {:ok, files} ->
        Enum.sort(files)

      {:error, reason} ->
        IO.inspect("Failed to list topics directory '#{topics_dir}': #{inspect(reason)}",
          label: "Topics Error"
        )

        # Return empty list on error to prevent crash, error will be logged.
        []
    end
  end
end
