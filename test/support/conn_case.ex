defmodule CodeComparisonWeb.ConnCase do
  @moduledoc false
  use ExUnit.CaseTemplate

  using do
    quote do
      import Plug.Conn
      import Phoenix.ConnTest
      import CodeComparisonWeb.ConnCase

      alias CodeComparisonWeb.Router.Helpers, as: Routes

      @endpoint CodeComparisonWeb.Endpoint
    end
  end

  setup _tags do
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end
end
