defmodule CodeComparisonWeb.HomeLive do
  @moduledoc false

  alias CodeComparison.{Languages, Topics}

  use Phoenix.LiveView
  use Phoenix.HTML

  @impl true
  def mount(_params, _session, socket) do
    topics = Topics.get_topics()

    if topics == [] do
      socket =
        socket
        |> assign(selected_topic: nil)
        |> assign(topics: [])
        # Default empty struct
        |> assign(language1: CodeComparison.Structs.Language.build(%{}))
        # Default empty struct
        |> assign(language2: CodeComparison.Structs.Language.build(%{}))
        |> assign(languages: [])

      {:ok, socket}
    else
      # Safe as topics is not empty
      first_topic = List.first(topics)
      # This can be []
      languages = Languages.get_languages_by_topic(first_topic)

      # If languages is empty, get_language_by_topic will return an empty Language struct
      # because Languages.get_language (which it calls) returns an empty struct for an empty list.
      # If languages is not empty, it will use the first language's name.
      # An empty name for default_lang_name will result in the first language being chosen by get_language if languages is not empty,
      # or an empty struct if languages is empty.
      default_lang_name = if languages != [], do: List.first(languages).name, else: ""

      language1_struct = Languages.get_language_by_topic(first_topic, default_lang_name)
      language2_struct = Languages.get_language_by_topic(first_topic, default_lang_name)

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
    topic = Map.get(values, "topic")
    languages = Languages.get_languages_by_topic(topic)
    language1 = Languages.get_language(languages, Map.get(values, "language1"))
    language2 = Languages.get_language(languages, Map.get(values, "language2"))

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
    topic = Map.get(values, "topic")
    language_struct = Languages.get_language_by_topic(topic, Map.get(values, language))

    {:noreply,
     socket
     |> assign(String.to_atom(language), language_struct)
     |> push_event("highlightAll", %{})}
  end
end
