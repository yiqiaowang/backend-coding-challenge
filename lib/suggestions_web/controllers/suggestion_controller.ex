defmodule SuggestionsWeb.SuggestionController do
  use SuggestionsWeb, :controller

  # Controller action for handling querystring and location information
  def query(conn, %{
    "q" => querystring,
    "latitude" => latitude,
    "longitude" => longitude
  }) do
    json conn, %{
      q: querystring,
      latitude: latitude,
      longitude: longitude
    }
  end

  # Controller action for handling querystring
  def query(conn, %{
    "q" => querystring
  }) do
    json conn, %{
      q: querystring
    }
  end
end
