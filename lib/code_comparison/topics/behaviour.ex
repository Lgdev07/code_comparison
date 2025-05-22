defmodule CodeComparison.Topics.Behaviour do
  @moduledoc """
  Behaviour for the Topics module, primarily for mocking in tests.
  """
  @callback get_topics() :: list(String.t())
end
