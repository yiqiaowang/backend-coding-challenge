defmodule Suggestions.Util.Scorer do
  @moduledoc """
  Implements functions for assigning scores to suggestions
  """
  require Logger
  alias Suggestions.Trie.Value

  def assign_scores(query, suggestions, opts \\ %{}) do
    case opts do
      %{latitude: lat, longitude: long} ->
        Enum.map(suggestions, fn x -> score(query, x, lat, long) end)

      _ ->
        Enum.map(suggestions, fn x -> score(query, x) end)
    end
  end

  defp score(query, %Value{} = suggestion) do
    %{suggestion | score: score_jaro(query, suggestion) + score_population(suggestion)}
  end

  defp score(query, %Value{} = suggestion, latitude, longitude) do
    %{
      suggestion
      | score:
          score_jaro(query, suggestion) + score_population(suggestion) +
            score_dist(suggestion, latitude, longitude)
    }
  end

  # Gives a fixed bias to populous cities
  defp score_population(%Value{population: population}) do
    population = String.to_integer(population)

    score =
      if population > 100_000 do
        0.3
      else
        0
      end

    Logger.debug("scored population #{population} -> #{score}")
    score
  end

  # Gives a fixed bias to nearby cities
  defp score_dist(%Value{latitude: lat, longitude: long}, target_lat, target_long) do
    dist =
      approximate_dist(
        String.to_float(lat),
        String.to_float(long),
        target_lat,
        target_long
      )

    score =
      if dist < 100 do
        0.3
      else
        0
      end

    Logger.debug("scored distance #{dist} -> #{score}")
    score
  end

  # Get the jaro-winkler distance
  defp score_jaro(query, suggestion) do
    score = String.jaro_distance(query, suggestion.name)
    Logger.debug("scored Jaro-Winkler #{suggestion.name} -> #{score}")
    score
  end

  # Approximate distnace in KM between coordinates
  def approximate_dist(p, q, x, y) do
    # Distance in KM per degree at equator
    length_at_equator = 110.25
    a = p - x
    b = (q - y) * :math.cos(x)
    length_at_equator * :math.sqrt(:math.pow(a, 2) + :math.pow(b, 2))
  end
end
