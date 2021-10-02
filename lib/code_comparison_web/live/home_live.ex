defmodule CodeComparisonWeb.HomeLive do
  @moduledoc false

  alias CodeComparison.{Languages, Topics}

  use Phoenix.LiveView
  use Phoenix.HTML

  @impl true
  def mount(_params, _session, socket) do
    topics = Topics.get_topics()
    first_topic = List.first(topics)

    languages = Languages.get_languages_by_topic(first_topic)
    language = Languages.get_language_by_topic(first_topic, List.first(languages).name)

    socket =
      socket
      |> assign(selected_topic: first_topic)
      |> assign(topics: topics)
      |> assign(language1: language)
      |> assign(language2: language)
      |> assign(languages: languages)

    {:ok, socket}
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
