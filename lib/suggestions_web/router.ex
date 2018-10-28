defmodule SuggestionsWeb.Router do
  use SuggestionsWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/", SuggestionsWeb do
    pipe_through(:api)
    get("/suggestions", SuggestionController, :query)
  end
end
