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
        |> trim_suggestions
        |> normalize_scores
        |> filter_suggestions
        |> format_suggestions
        |> remove_duplicates
    }
  end

  defp normalize_scores(suggestions) do
    max_score = Enum.max(Enum.map(suggestions, fn x -> x.score end))
    Enum.map(suggestions, fn x -> %{x | score: x.score / max_score} end)
  end

  defp sort_suggestions(suggestions) do
    Enum.sort_by(suggestions, fn x -> x.score end, &>=/2)
  end

  defp filter_suggestions(suggestions) do
    Enum.take_while(suggestions, fn x -> x.score >= 0.9 end)
  end

  defp trim_suggestions(suggestions) do
    Enum.take(suggestions, max(trunc(Enum.count(suggestions) * 0.2), 5))
  end

  defp format_suggestions(suggestions) do
    Enum.map(suggestions, fn x -> format(x) end)
  end

  defp format(suggestion) do
    %{
      name: suggestion.name,
      score: suggestion.score,
      latitude: suggestion.latitude,
      longitude: suggestion.longitude
    }
  end

  defp remove_duplicates(suggestions) do
    Enum.uniq_by(suggestions, fn x -> x.name end)
  end
end
