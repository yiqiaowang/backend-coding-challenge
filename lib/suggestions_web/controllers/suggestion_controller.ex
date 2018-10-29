defmodule SuggestionsWeb.SuggestionController do
  use SuggestionsWeb, :controller

  alias Suggestions.Query.Worker

  # Controller action for handling querystring and location information
  def query(conn, %{
        "q" => querystring,
        "latitude" => latitude,
        "longitude" => longitude
      }) do
    suggestions = Worker.query(querystring, latitude, longitude)
    render(conn, "index.json", suggestions: suggestions)
  end

  # Controller action for handling querystring
  def query(conn, %{
        "q" => querystring
      }) do
    suggestions = Worker.query(querystring)
    render(conn, "index.json", suggestions: suggestions)
  end
end
