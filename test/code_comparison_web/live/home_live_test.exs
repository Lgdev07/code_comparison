defmodule CodeComparisonWeb.HomeLiveTest do
  use CodeComparisonWeb.ConnCase

  import Phoenix.LiveViewTest

  import Mox

  setup do
    CodeComparison.Integrations.Github.ApiMock
    |> expect(:call, 4, fn
      %{method: :get}, _opts ->
        {:ok,
         %Tesla.Env{
           status: 200,
           body: [%{"author" => %{"login" => "test", "html_url" => "url_test"}}]
         }}
    end)

    :ok
  end

  describe "testing the topic changes" do
    test "should not assert since the topic does not exist", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      refute view
             |> element("form")
             |> render_change(%{"_target" => ["topic"], "topic" => "List"}) =~ "not a topic"
    end

    test "should assert since the topic List exist", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert view
             |> element("form")
             |> render_change(%{"_target" => ["topic"], "topic" => "List"}) =~ "List"
    end

    test "should assert since the topic Map exist", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert view
             |> element("form")
             |> render_change(%{"_target" => ["topic"], "topic" => "Map"}) =~ "Map"
    end
  end

  describe "testing the language changes" do
    test "should assert since the language Go exist", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert view
             |> element("form")
             |> render_change(%{"_target" => ["language1"], "language1" => "Go", "topic" => "Map"}) =~
               "Go"
    end

    test "should assert since the language does not exist", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      refute view
             |> element("form")
             |> render_change(%{"_target" => ["language1"], "language1" => "Go", "topic" => "Map"}) =~
               "not a language"
    end
  end
end
