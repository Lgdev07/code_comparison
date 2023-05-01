defmodule CodeComparison.Topics do
  @moduledoc false

  @spec get_topics :: list
  def get_topics do
    File.ls!("#{File.cwd!()}/topics")
    |> Enum.sort()
  end
end
