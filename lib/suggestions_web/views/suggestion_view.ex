defmodule SuggestionsWeb.SuggestionView do
  @moduledoc """
  Format the JSON response.
  """

  use SuggestionsWeb, :view

  def render("index.json", %{suggestions: suggestions}) do
    %{
      suggestions:
        suggestions
        |> sort_suggestions
        |> normalize_scores
        |> trim_suggestions
    }
  end

  defp normalize_scores(suggestions) do
    max_score = Enum.max(Enum.map(suggestions, fn x -> x.score end))
    Enum.map(suggestions, fn x -> %{x | score: x.score / max_score} end)
  end

  defp sort_suggestions(suggestions) do
    Enum.sort_by(suggestions, fn x -> x.score end, &>=/2)
  end

  defp trim_suggestions(suggestions) do
    Enum.take_while(suggestions, fn x -> x.score >= 0.75 end)
  end
end
