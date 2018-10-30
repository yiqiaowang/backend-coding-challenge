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
        |> prefilter_suggestions
        |> normalize_scores
        |> postfilter_suggestions
        |> format_suggestions
        |> remove_duplicates
    }
  end

  defp normalize_scores([_ | _] = suggestions) do
    max_score = Enum.max(Enum.map(suggestions, fn x -> x.score end))
    Enum.map(suggestions, fn x -> %{x | score: x.score / max_score} end)
  end

  defp normalize_scores(_) do
    []
  end

  defp sort_suggestions(suggestions) do
    Enum.sort_by(suggestions, fn x -> x.score end, &>=/2)
  end

  defp prefilter_suggestions(suggestions) do
    Enum.take_while(suggestions, fn x -> x.score >= 0.7 end)
  end

  defp postfilter_suggestions(suggestions) do
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
