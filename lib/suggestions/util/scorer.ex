defmodule Suggestions.Util.Scorer do
  @moduledoc """
  Implements functions for assigning scores to suggestions
  """
  require Logger
  alias Suggestions.Trie.Value

  def assign_scores(suggestions, opts \\ %{}) do
    case opts do
      %{latitude: lat, longitude: long} ->
        Enum.map(suggestions, fn x -> score(x, lat, long) end)

      _ ->
        Enum.map(suggestions, fn x -> score(x) end)
    end
  end

  defp score(%Value{} = suggestion) do
    %{suggestion | score: score_population(suggestion)}
  end

  defp score(%Value{} = suggestion, latitude, longitude) do
    %{
      suggestion
      | score: score_population(suggestion) + score_prefix(suggestion) +
        score_dist(suggestion, latitude, longitude)
    }
  end

  # Give fixed score boost to prefix matches
  defp score_prefix(%Value{is_prefix: is_prefix}) do
    is_prefix
  end

  # Assign a score to the population by binning into groups
  defp score_population(%Value{population: population}) do
    population = String.to_integer(population)

    score =
      cond do
        population < 10_000 -> 0.1
        population < 100_000 -> 0.4
        population < 1_000_000 -> 0.8
        true -> 1
      end

    Logger.debug("scored population #{population} -> #{score}")
    score
  end

  # Assign a score to the distance by binning in to groups
  defp score_dist(%Value{latitude: lat, longitude: long}, target_lat, target_long) do
    dist =
      approximate_dist(
        String.to_float(lat),
        String.to_float(long),
        target_lat,
        target_long
      )

    score =
      cond do
        dist < 10 -> 1
        dist < 100 -> 0.5
        dist < 500 -> 0.25
        true -> 0.1
      end

    Logger.debug("scored distance #{dist} -> #{score}")
    score
  end

  # Approximate distnace between coordinates
  defp approximate_dist(p, q, x, y) do
    # Distance in KM per degree at equator
    length_at_equator = 110.25
    a = p - x
    b = (q - y) * :math.cos(x)
    length_at_equator * :math.sqrt(:math.pow(a, 2) + :math.pow(b, 2))
  end
end
