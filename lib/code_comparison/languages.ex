defmodule CodeComparison.Languages do
  @moduledoc false

  alias CodeComparison.Integrations.Github
  alias CodeComparison.Structs.Language

  # Helper to get the base path for topics
  defp base_topics_path, do: Path.join(Application.app_dir(:code_comparison), "topics")

  @spec get_languages_by_topic(String.t()) :: list(%Language{})
  def get_languages_by_topic(topic) do
    topic_dir = Path.join(base_topics_path(), topic)
    case File.ls(topic_dir) do
      {:ok, files} ->
        files
        |> Enum.map(&(String.split(&1, ".") |> List.first()))
        |> Enum.map(&language_build(&1, topic)) # language_build handles its own file reads using new path logic
        |> Enum.sort_by(& &1.name)
      {:error, reason} ->
        IO.inspect("Failed to list languages for topic '#{topic}' at '#{topic_dir}': #{inspect(reason)}", label: "Languages Error")
        []
    end
  end

  @spec get_language_code(String.t(), String.t()) :: String.t()
  def get_language_code(language_name, topic) do
    filename = get_filename(language_name, topic) # This will use the updated get_filename

    if filename == nil do
      IO.inspect("Filename not found for language '#{language_name}' in topic '#{topic}' when getting code.", label: "Languages Error")
      ""
    else
      file_path = Path.join([base_topics_path(), topic, filename])
      case File.read(file_path) do
        {:ok, code} -> code
        {:error, reason} ->
          IO.inspect("Failed to read language code for '#{language_name}' from '#{file_path}': #{inspect(reason)}", label: "Languages Error")
          ""
      end
    end
  end

  @spec get_filename(String.t(), String.t()) :: String.t() | nil
  defp get_filename(language_name, topic) do
    topic_dir = Path.join(base_topics_path(), topic)
    case File.ls(topic_dir) do
      {:ok, files} ->
        Enum.find(files, &(String.split(&1, ".") |> List.first() == language_name))
      {:error, reason} ->
        IO.inspect("Failed to list files in '#{topic_dir}' to find filename for '#{language_name}': #{inspect(reason)}", label: "Languages Error")
        nil
    end
  end

  @spec get_language(list(%Language{}), String.t()) :: %Language{}
  def get_language(topic_languages, current_language_name) do
    if topic_languages == [] do
      %Language{ # Using alias for brevity
        name: "", code: "", topic: "", commiter_name: "", commiter_url: "", path: ""
      }
    else
      # The topic should ideally be consistent for all languages in topic_languages.
      # Taking it from the first element.
      topic = List.first(topic_languages).topic

      # Find if the current_language_name exists in the list
      found_language_struct = Enum.find(topic_languages, &(&1.name == current_language_name))

      cond do
        found_language_struct -> # Language found in the pre-loaded list
          found_language_struct |> put_commit_values()
        true -> # Language not found by name, or current_language_name is empty. Default to first.
                # This path also handles if current_language_name was for a language not in this topic.
                # The original code's `Enum.member?` check followed by `language_build` or `List.first`
                # had a subtle difference. `language_build` would reload the code.
                # Here, we assume `topic_languages` are complete structs.
                # If `current_language_name` isn't in the list, we take the first.
          topic_languages |> List.first() |> put_commit_values()
      end
    end
  end

  @spec get_language_by_topic(String.t(), String.t()) :: %Language{}
  def get_language_by_topic(topic, current_language_name) do
    # This function, as per existing code, rebuilds the language struct.
    # It's used in HomeLive mount and language change event.
    language_build(current_language_name, topic) # This now uses new path logic internally
    |> put_commit_values()
  end

  defp language_build(language_name, topic) do
    # get_filename now returns nil if not found
    filename = get_filename(language_name, topic)

    github_path =
      if filename do
        "topics/#{topic}/#{filename}"
      else
        IO.inspect("Filename is nil for language '#{language_name}' in topic '#{topic}' during language_build. Path will be empty.", label: "Languages Warning")
        "" # Empty path if filename couldn't be determined
      end

    Language.build(%{
      name: language_name,
      code: get_language_code(language_name, topic), # Uses new path logic and error handling
      topic: topic,
      path: String.replace(github_path, " ", "%20") # Path for GitHub API
    })
  end

  # put_commit_values and its helpers remain largely the same,
  # but they operate on the `language.path` which is now built carefully.
  defp put_commit_values(language) do
    # Ensure path is not empty before calling GitHub API
    if language.path && language.path != "" do
      case Application.get_env(:code_comparison, :github)[:token] do
        nil -> put_empty_commit_values(language)
        _ -> # Pass the actual language struct, not just path
             put_commit_values_with_api(language, Github.get_last_commit(language.path))
      end
    else
      put_empty_commit_values(language) # Path is empty, skip GitHub call
    end
  end

  # Renamed to avoid clash and clarify it's the one calling API
  defp put_commit_values_with_api(language, {:ok, body}) do
    # Assuming body structure is a list of commits
    first_commit = List.first(body) # Safe navigation for author needed
    
    author_name = first_commit |> get_in(["author", "login"])
    author_url = first_commit |> get_in(["author", "html_url"])

    # Handle nil author_name/url if path is invalid or commit data is unexpected
    Map.merge(language, %{
      commiter_name: author_name || "",
      commiter_url: author_url || ""
    })
  end

  defp put_commit_values_with_api(language, {:error, _reason}) do
    # IO.inspect("GitHub API error for #{language.path}: #{inspect(_reason)}", label: "Languages Error")
    put_empty_commit_values(language)
  end

  defp put_empty_commit_values(language) do
    Map.merge(language, %{
      commiter_name: "",
      commiter_url: ""
    })
  end
end
