defmodule CodeComparison.Languages.Behaviour do
  @moduledoc """
  Behaviour for the Languages module, primarily for mocking in tests.
  """
  alias CodeComparison.Structs.Language

  @callback get_languages_by_topic(String.t()) :: list(%Language{})
  @callback get_language(list(%Language{}), String.t()) :: %Language{}
  @callback get_language_by_topic(String.t(), String.t()) :: %Language{}
  # This one is also used internally by HomeLive and relies on file reads
  @callback get_all_languages_from_topic_list(list(String.t())) :: list(%Language{})
  # This one is used by HomeLive's handle_event for language updates
  # and directly reads files.
  # However, for the current tests, focusing on topic changes and initial mount,
  # we might not need to mock it if we ensure get_languages_by_topic and get_language
  # are well-behaved. The existing handle_event for single language change might
  # not be directly tested by these scenarios for empty states.
  # Let's add it for completeness as it's part of the public API of Languages module.
  @callback language_build(String.t(), String.t()) :: %Language{}
end
