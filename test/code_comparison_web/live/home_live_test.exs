defmodule CodeComparisonWeb.HomeLiveTest do
  use CodeComparisonWeb.ConnCase

  import Phoenix.LiveViewTest

  describe "testing the topic changes" do
    test "should not assert since the topic does not exist", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      refute view
             |> element("form")
             |> render_change(%{"_target" => ["topic"], "topic" => "list"}) =~ "not a topic"
    end

    test "should assert since the topic list exist", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert view
             |> element("form")
             |> render_change(%{"_target" => ["topic"], "topic" => "list"}) =~ "list"
    end

    test "should assert since the topic map exist", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert view
             |> element("form")
             |> render_change(%{"_target" => ["topic"], "topic" => "map"}) =~ "map"
    end
  end

  describe "testing the language changes" do
    test "should assert since the language go exist", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert view
             |> element("form")
             |> render_change(%{"language1" => "go", "topic" => "map"}) =~ "go"
    end

    test "should assert since the language elixir exist", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      assert view
             |> element("form")
             |> render_change(%{"language1" => "go", "topic" => "map"}) =~ "elixir"
    end

    test "should assert since the language does not exist", %{conn: conn} do
      {:ok, view, _html} = live(conn, "/")

      refute view
             |> element("form")
             |> render_change(%{"language1" => "go", "topic" => "map"}) =~ "not a language"
    end
  end
end
