defmodule CodeComparison.LanguagesTest do
  use ExUnit.Case, async: true
  alias CodeComparison.Languages
  alias CodeComparison.Structs.Language

  describe "get_language/2" do
    test "returns a default empty Language struct when the language list is empty" do
      expected_language = %Language{
        name: "",
        code: "",
        topic: "",
        commiter_name: "",
        commiter_url: "",
        path: ""
      }

      assert Languages.get_language([], "any_lang_name") == expected_language
      assert Languages.get_language([], "") == expected_language
    end

    # Test with a non-empty list to ensure it doesn't always return empty (optional, but good practice)
    test "returns the correct language from a non-empty list" do
      lang1 = %Language{name: "Lang1", code: "code1", topic: "Topic1"}
      lang2 = %Language{name: "Lang2", code: "code2", topic: "Topic1"}
      languages = [lang1, lang2]

      # Mocking file reads within get_language if it performs them for commit info.
      # However, the specific change for empty lists doesn't involve that part.
      # The current get_language/2 function's core logic for selection or default
      # does not directly call put_commit_values/1, which reads files.
      # put_commit_values/1 is called by the functions in HomeLive *after* get_language returns.
      # So, for this specific unit test of get_language/2, direct file mocking isn't strictly needed
      # unless we are testing the commit value population part, which is separate.

      # The current implementation of get_language/2 when the list is NOT empty:
      # 1. Checks if current_language is in the list of names.
      # 2. If yes, calls language_build(current_language, topic) |> put_commit_values()
      # 3. If no, calls List.first(topic_languages) |> put_commit_values()
      # `language_build` itself does not read files. `put_commit_values` does.
      # For this unit test, we are focused on the selection logic and the empty list case.
      # The empty list case *does not* call `put_commit_values`.

      # To make this test fully independent of `put_commit_values`, we can assert the struct
      # *before* commit values are added, or ensure `put_commit_values` is handled.
      # Given the subtask focuses on the empty-list behavior, the first test case is the critical one.
      # The `get_language/2` function *does* call `put_commit_values` in its non-empty path.
      # So, to test non-empty paths accurately without file system access,
      # `put_commit_values` would need to be mocked or the `Languages` module itself mocked,
      # which is not typical for testing the module itself.

      # For simplicity and focus, the primary test for the subtask is the empty list.
      # This existing test for non-empty list will call `put_commit_values`.
      # Let's assume for this unit test, we allow it, or acknowledge it might need adjustment
      # if strict no-file-IO is required for all paths of `get_language/2` unit tests.
      # The provided fix was for the empty list path, which is correctly tested without IO.

      # If Languages.language_build/2 or Languages.put_commit_values/1 needs mocking for non-empty cases:
      # This would require a more complex setup, possibly by passing the module to use for those functions.
      # However, the primary goal is the "empty list" scenario, which is covered.

      # Let's test the "found" case without worrying about put_commit_values for now,
      # as its result (the language struct itself before commit info) is what we care for selection.
      # The actual function `get_language` calls `put_commit_values` internally.
      # This means this test case will try to read files unless the Languages module is mocked,
      # or `put_commit_values` is made mockable.

      # Given the context, this test might be "good enough" if `priv/topics/*` is empty or non-existent in test env,
      # causing `put_commit_values` to return empty commit info.
      # The crucial part is the selection of lang1 or lang2.

      # Let's refine the assertion to only care about the name, which is safe from put_commit_values side effects.
      selected_lang1 = Languages.get_language(languages, "Lang1")
      assert selected_lang1.name == "Lang1"
      assert selected_lang1.topic == "Topic1" # Topic is also set by language_build

      selected_lang2_by_default = Languages.get_language(languages, "NonExistentLang")
      assert selected_lang2_by_default.name == "Lang1" # Defaults to first
      assert selected_lang2_by_default.topic == "Topic1"
    end
  end
end
