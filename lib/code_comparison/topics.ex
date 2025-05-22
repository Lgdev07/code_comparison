defmodule CodeComparison.Topics do
  @moduledoc false

  @spec get_topics :: list
  def get_topics do
    # topics_dir is expected to be at the root of the application.
    # Application.app_dir(:code_comparison) should point to the app's root directory (e.g., /app or /code_comparison).
    topics_dir = Path.join(Application.app_dir(:code_comparison), "topics")
    
    case File.ls(topics_dir) do
      {:ok, files} -> Enum.sort(files)
      {:error, reason} ->
        IO.inspect("Failed to list topics directory '#{topics_dir}': #{inspect(reason)}", label: "Topics Error")
        [] # Return empty list on error to prevent crash, error will be logged.
    end
  end
end
