defmodule CodeComparison.Languages do
  @moduledoc false

  alias CodeComparison.Integrations.Github
  alias CodeComparison.Structs.Language

  @spec get_languages_by_topic(String.t()) :: list
  def get_languages_by_topic(topic) do
    File.ls!("topics/#{topic}")
    |> Enum.map(&(String.split(&1, ".") |> List.first()))
    |> Enum.map(&language_build(&1, topic))
    |> Enum.sort_by(& &1.name)
  end

  @spec get_language_code(String.t(), String.t()) :: String.t()
  def get_language_code(language, topic) do
    filename = get_filename(language, topic)
    File.read!("topics/#{topic}/#{filename}")
  end

  @spec get_filename(String.t(), String.t()) :: String.t()
  defp get_filename(language, topic) do
    File.ls!("topics/#{topic}")
    |> Enum.find(&(String.split(&1, ".") |> List.first() == language))
  end

  @spec get_language(list(), String.t()) :: %Language{}
  def get_language(topic_languages, current_language) do
    topic = List.first(topic_languages).topic

    case Enum.member?(Enum.map(topic_languages, & &1.name), current_language) do
      true -> language_build(current_language, topic) |> put_commit_values()
      false -> topic_languages |> List.first() |> put_commit_values()
    end
  end

  @spec get_language_by_topic(String.t(), String.t()) :: %Language{}
  def get_language_by_topic(topic, current_language) do
    language_build(current_language, topic)
    |> put_commit_values()
  end

  defp language_build(language, topic) do
    Language.build(%{
      name: language,
      code: get_language_code(language, topic),
      topic: topic,
      path: String.replace("topics/#{topic}/#{get_filename(language, topic)}", " ", "%20")
    })
  end

  defp put_commit_values(language) do
    case Application.get_env(:code_comparison, :github)[:token] do
      nil -> put_empty_commit_values(language)
      _ -> put_commit_values(language, Github.get_last_commit(language.path))
    end
  end

  defp put_commit_values(language, {:ok, body}) do
    author_name =
      body
      |> List.first()
      |> get_in(["author", "login"])

    author_url =
      body
      |> List.first()
      |> get_in(["author", "html_url"])

    Map.merge(language, %{
      commiter_name: author_name,
      commiter_url: author_url
    })
  end

  defp put_commit_values(language, {:error, _reason}), do: put_empty_commit_values(language)

  defp put_empty_commit_values(language),
    do:
      Map.merge(language, %{
        commiter_name: "",
        commiter_url: ""
      })
end
