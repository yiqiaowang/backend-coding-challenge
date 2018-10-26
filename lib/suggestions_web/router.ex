defmodule SuggestionsWeb.Router do
  use SuggestionsWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", SuggestionsWeb do
    pipe_through :api
  end
end
