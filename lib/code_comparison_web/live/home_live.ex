defmodule CodeComparisonWeb.HomeLive do
  @moduledoc false

  use Phoenix.LiveView
  use Phoenix.HTML

  @impl true
  def mount(_params, _session, socket) do
    topics_module = Application.get_env(:code_comparison, :topics_module, CodeComparison.Topics)

    languages_module =
      Application.get_env(:code_comparison, :languages_module, CodeComparison.Languages)

    topics = topics_module.get_topics()

    if topics == [] do
      empty_language = %{
        name: "",
        code: "",
        topic: "",
        path: ""
      }

      socket =
        socket
        |> assign(selected_topic: nil)
        |> assign(topics: [])
        # Default empty struct with required fields
        |> assign(language1: CodeComparison.Structs.Language.build(empty_language))
        # Default empty struct with required fields
        |> assign(language2: CodeComparison.Structs.Language.build(empty_language))
        |> assign(languages: [])

      {:ok, socket}
    else
      # Safe as topics is not empty
      first_topic = List.first(topics)
      # This can be []
      languages = languages_module.get_languages_by_topic(first_topic)

      # If languages is empty, get_language will return an empty Language struct
      # If languages is not empty, it will use the first language's name.
      default_lang_name = if languages != [], do: List.first(languages).name, else: ""

      # Use get_language instead of get_language_by_topic to avoid duplicate get_languages_by_topic call
      language1_struct = languages_module.get_language(languages, default_lang_name)
      language2_struct = languages_module.get_language(languages, default_lang_name)

      socket =
        socket
        |> assign(selected_topic: first_topic)
        |> assign(topics: topics)
        |> assign(language1: language1_struct)
        |> assign(language2: language2_struct)
        |> assign(languages: languages)

      {:ok, socket}
    end
  end

  @impl true
  def handle_event("update", %{"_target" => ["topic"]} = values, socket) do
    languages_module =
      Application.get_env(:code_comparison, :languages_module, CodeComparison.Languages)

    topic = Map.get(values, "topic")
    languages = languages_module.get_languages_by_topic(topic)
    language1 = languages_module.get_language(languages, Map.get(values, "language1"))
    language2 = languages_module.get_language(languages, Map.get(values, "language2"))

    {:noreply,
     socket
     |> assign(selected_topic: topic)
     |> assign(language1: language1)
     |> assign(language2: language2)
     |> assign(languages: languages)
     |> push_event("highlightAll", %{})}
  end

  @impl true
  def handle_event("update", %{"_target" => [language]} = values, socket) do
    languages_module =
      Application.get_env(:code_comparison, :languages_module, CodeComparison.Languages)

    topic = Map.get(values, "topic")
    languages = languages_module.get_languages_by_topic(topic)
    language_struct = languages_module.get_language(languages, Map.get(values, language))

    {:noreply,
     socket
     |> assign(String.to_atom(language), language_struct)
     |> push_event("highlightAll", %{})}
  end
end
