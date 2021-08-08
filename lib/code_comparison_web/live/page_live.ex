defmodule CodeComparisonWeb.PageLive do
  use Phoenix.LiveView
  use Phoenix.HTML

  @impl true
  def mount(_params, _session, socket) do
    topics = get_topics()
    first_topic = get_topics() |> List.first()
    languages = first_topic |> get_languages_by_topic()
    language = languages |> List.first()

    language_code = get_language_code(language, first_topic)

    socket =
      socket
      |> assign(topic: "")
      |> assign(language1: language)
      |> assign(language2: language)
      |> assign(topics: topics)
      |> assign(languages: languages)
      |> assign(language1_code: language_code)
      |> assign(language2_code: language_code)

    {:ok, socket}
  end

  @impl true
  def handle_event("update", %{"_target" => ["topic"]} = values, socket) do
    topic = Map.get(values, "topic")
    language1 = Map.get(values, "language1")
    language2 = Map.get(values, "language2")

    languages = get_languages_by_topic(topic)

    language1 = get_language(languages, language1)
    language2 = get_language(languages, language2)

    {:noreply,
      socket
      |> assign(topic: topic)
      |> assign(language1: language1)
      |> assign(language2: language2)
      |> assign(languages: get_languages_by_topic(topic))
      |> assign(language1_code: get_language_code(language1, topic))
      |> assign(language2_code: get_language_code(language2, topic))
      |> push_event("highlightAll", %{})
    }
  end

  @impl true
  def handle_event("update", values, socket) do
    topic = Map.get(values, "topic")
    language1 = Map.get(values, "language1")
    language2 = Map.get(values, "language2")

    {:noreply,
      socket
      |> assign(topic: topic)
      |> assign(language1: language1)
      |> assign(language2: language2)
      |> assign(language1_code: get_language_code(language1, topic))
      |> assign(language2_code: get_language_code(language2, topic))
      |> push_event("highlightAll", %{})
    }
  end

  defp get_language(topic_languages, current_language) do
    case Enum.member?(topic_languages, current_language) do
      true -> current_language
      false -> topic_languages |> List.first()
    end
  end

  defp get_topics do
    File.ls!("topics")
    |> Enum.sort()
  end

  defp get_language_code(language, topic) do
    file_name =
      File.ls!("topics/#{topic}")
      |> Enum.find(&String.contains?(&1, language))

    File.read!("topics/#{topic}/#{file_name}")
  end

  defp get_languages_by_topic(topic) do
    File.ls!("topics/#{topic}")
    |> Enum.map(&String.split(&1, ".") |> List.first())
    |> Enum.sort()
  end
end
