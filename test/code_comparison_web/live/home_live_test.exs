defmodule CodeComparisonWeb.HomeLiveTest do
  use CodeComparisonWeb.ConnCase
  import Phoenix.LiveViewTest

  alias CodeComparison.Structs.Language
  alias CodeComparison.{LanguagesMock, TopicsMock}

  @empty_lang_struct %Language{
    name: "",
    code: "",
    topic: "",
    commiter_name: "",
    commiter_url: "",
    path: ""
  }

  setup do
    # Set the application config to use our mock modules
    Application.put_env(:code_comparison, :topics_module, TopicsMock)
    Application.put_env(:code_comparison, :languages_module, LanguagesMock)
    :ok
  end

  describe "Initial Mount Scenarios" do
    test "mounts with no topics available" do
      TopicsMock
      |> Mox.expect(:get_topics, fn -> [] end)
      |> Mox.expect(:get_topics, fn -> [] end)

      # The mount logic for empty topics assigns default empty Language structs via CodeComparison.Structs.Language.build(%{})
      # It does not call Languages module functions like get_languages_by_topic or get_language_by_topic if topics list is empty.

      {:ok, view, html} = live_isolated(build_conn(), CodeComparisonWeb.HomeLive)

      assert html =~ "No topics available"
      # When topics are empty, languages list is also empty.
      # The template shows "No languages available" for the language selectors section.
      assert html =~ "No languages available"
      # Check for disabled select for topics
      assert html =~
               ~s(<select name="topic" disabled="disabled" class="w-full px-3 py-2 mt-1 bg-gray-200 text-gray-500 border border-gray-300 rounded-md shadow-sm focus:outline-none sm:text-sm">)

      assert html =~ ~s(<option>No topics available</option>)
      # Check for disabled selects for languages
      assert html =~
               ~s(<select name="language1_disabled" disabled="disabled" class="w-full px-3 py-2 mt-1 bg-gray-200 text-gray-500 border border-gray-300 rounded-md shadow-sm focus:outline-none sm:text-sm">)

      assert html =~ ~s(<option>No languages available</option>)

      assert html =~
               ~s(<select name="language2_disabled" disabled="disabled" class="w-full px-3 py-2 mt-1 bg-gray-200 text-gray-500 border border-gray-300 rounded-md shadow-sm focus:outline-none sm:text-sm">)

      assert html =~ ~s(<option>No languages available</option>)

      # Code display areas should show "No code to display"
      # and use "plaintext" class because language name will be empty.
      # The code blocks themselves are present, but contain the "No code to display" message.
      rendered_html = render(view)
      assert rendered_html =~ "No code to display."
    end

    test "mounts when the first topic has no languages" do
      TopicsMock
      |> Mox.expect(:get_topics, fn -> ["Topic1"] end)
      |> Mox.expect(:get_topics, fn -> ["Topic1"] end)

      LanguagesMock
      |> Mox.expect(:get_languages_by_topic, fn "Topic1" -> [] end)
      |> Mox.expect(:get_languages_by_topic, fn "Topic1" -> [] end)

      # mount will call get_language([], "") -> returns @empty_lang_struct
      LanguagesMock
      # For language1
      |> Mox.expect(:get_language, fn [], "" -> @empty_lang_struct end)
      |> Mox.expect(:get_language, fn [], "" -> @empty_lang_struct end)

      LanguagesMock
      # For language2
      |> Mox.expect(:get_language, fn [], "" -> @empty_lang_struct end)
      |> Mox.expect(:get_language, fn [], "" -> @empty_lang_struct end)

      {:ok, view, html} = live_isolated(build_conn(), CodeComparisonWeb.HomeLive)

      # Instead of string match, use Floki to check for selected option
      assert Floki.find(html, "option[selected][value=\"Topic1\"]") |> Floki.text() == "Topic1"
      # For language selectors part
      assert html =~ "No languages available"
      # Check for disabled selects for languages
      assert html =~
               ~s(<select name="language1_disabled" disabled="disabled" class="w-full px-3 py-2 mt-1 bg-gray-200 text-gray-500 border border-gray-300 rounded-md shadow-sm focus:outline-none sm:text-sm">)

      assert html =~ ~s(<option>No languages available</option>)

      assert html =~
               ~s(<select name="language2_disabled" disabled="disabled" class="w-full px-3 py-2 mt-1 bg-gray-200 text-gray-500 border border-gray-300 rounded-md shadow-sm focus:outline-none sm:text-sm">)

      assert html =~ ~s(<option>No languages available</option>)

      # Code display areas should show "No code to display."
      # and use "plaintext" class because language name will be empty.
      rendered_html = render(view)
      assert rendered_html =~ "No code to display."
    end
  end

  describe "Topic Change Scenarios" do
    test "topic change to a topic with no languages" do
      # Initial state: "TopicWithLangs" has "Lang1"
      lang1_topic_with_langs = %Language{
        name: "Lang1",
        code: "code for Lang1",
        topic: "TopicWithLangs",
        commiter_name: "commiter1",
        commiter_url: "url1",
        path: "/path/to/lang1"
      }

      TopicsMock
      |> Mox.expect(:get_topics, fn -> ["TopicWithLangs", "TopicWithoutLangs"] end)
      |> Mox.expect(:get_topics, fn -> ["TopicWithLangs", "TopicWithoutLangs"] end)

      # Mount sequence for "TopicWithLangs"
      LanguagesMock
      # For initial languages list
      |> Mox.expect(:get_languages_by_topic, fn "TopicWithLangs" -> [lang1_topic_with_langs] end)
      |> Mox.expect(:get_languages_by_topic, fn "TopicWithLangs" -> [lang1_topic_with_langs] end)

      LanguagesMock
      # For lang1
      |> Mox.expect(:get_language, fn [lang1_topic_with_langs], "Lang1" ->
        lang1_topic_with_langs
      end)
      |> Mox.expect(:get_language, fn [lang1_topic_with_langs], "Lang1" ->
        lang1_topic_with_langs
      end)

      LanguagesMock
      # For lang2
      |> Mox.expect(:get_language, fn [lang1_topic_with_langs], "Lang1" ->
        lang1_topic_with_langs
      end)
      |> Mox.expect(:get_language, fn [lang1_topic_with_langs], "Lang1" ->
        lang1_topic_with_langs
      end)

      {:ok, view, html} = live_isolated(build_conn(), CodeComparisonWeb.HomeLive)

      # Instead of string match, use Floki to check for selected option
      assert Floki.find(html, "option[selected][value=\"TopicWithLangs\"]") |> Floki.text() ==
               "TopicWithLangs"

      # Assuming Lang1 is the only/first language
      assert Floki.find(html, "option[selected][value=\"Lang1\"]")
             |> Enum.any?(fn node -> Floki.text(node) == "Lang1" end)

      assert html =~ "code for Lang1"
      assert html =~ ~s(<code class="language-Lang1">)

      # Setup mocks for topic change event
      # When "TopicWithoutLangs" is selected:
      LanguagesMock
      # This will be the new @languages
      |> Mox.expect(:get_languages_by_topic, fn "TopicWithoutLangs" -> [] end)
      |> Mox.expect(:get_languages_by_topic, fn "TopicWithoutLangs" -> [] end)

      # HomeLive's handle_event for topic change calls Languages.get_language(new_languages_list, previous_lang_name_from_form)
      # If new_languages_list is [], Languages.get_language returns @empty_lang_struct.
      # The previous_lang_name_from_form will be "Lang1" for both, as obtained from the form values.
      LanguagesMock
      # For language1 assign
      |> Mox.expect(:get_language, fn [], "Lang1" -> @empty_lang_struct end)
      |> Mox.expect(:get_language, fn [], "Lang1" -> @empty_lang_struct end)

      LanguagesMock
      # For language2 assign
      |> Mox.expect(:get_language, fn [], "Lang1" -> @empty_lang_struct end)
      |> Mox.expect(:get_language, fn [], "Lang1" -> @empty_lang_struct end)

      # Simulate topic change
      # The form values sent on change will include the *currently selected* language names.
      # In this case, language1 and language2 are both "Lang1".
      rendered_html_after_change =
        view
        |> element("form")
        |> render_change(%{
          "topic" => "TopicWithoutLangs",
          "language1" => "Lang1",
          "language2" => "Lang1",
          "_target" => ["topic"]
        })

      assert Floki.find(
               rendered_html_after_change,
               "option[selected][value=\"TopicWithoutLangs\"]"
             )
             |> Enum.any?(fn node -> Floki.text(node) == "TopicWithoutLangs" end)

      # For language selectors part
      assert rendered_html_after_change =~ "No languages available"
      # Check for disabled selects for languages
      assert rendered_html_after_change =~
               ~s(<select name="language1_disabled" disabled="disabled" class="w-full px-3 py-2 mt-1 bg-gray-200 text-gray-500 border border-gray-300 rounded-md shadow-sm focus:outline-none sm:text-sm">)

      assert rendered_html_after_change =~ ~s(<option>No languages available</option>)

      assert rendered_html_after_change =~
               ~s(<select name="language2_disabled" disabled="disabled" class="w-full px-3 py-2 mt-1 bg-gray-200 text-gray-500 border border-gray-300 rounded-md shadow-sm focus:outline-none sm:text-sm">)

      assert rendered_html_after_change =~ ~s(<option>No languages available</option>)

      # Code display areas
      assert rendered_html_after_change =~ "No code to display."
      # Check for the specific structure for plaintext code display
      assert rendered_html_after_change =~ ~s(<code class="language-plaintext">)
      # Ensure the "No code to display" span is present inside the code tag
      # Need to parse the HTML to check content of specific elements
      parsed_after_change = Floki.parse_document!(rendered_html_after_change)
      code_elements_after_change = Floki.find(parsed_after_change, "code.language-plaintext")

      assert Enum.all?(code_elements_after_change, fn {_tag, _attrs, children} ->
               Floki.text(children) =~ "No code to display."
             end)
    end
  end
end
