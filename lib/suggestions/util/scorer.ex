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
    score = score_jaro(query, suggestion) * pop_factor(suggestion)
    Logger.info("gave #{suggestion.name} score = #{score}")
    %{suggestion | score: score}
  end

  defp score(query, %Value{} = suggestion, latitude, longitude) do
    score =
      score_jaro(query, suggestion) * pop_factor(suggestion) *
        dist_factor(suggestion, latitude, longitude)

    Logger.info("gave #{suggestion.name} score = #{score}")
    %{suggestion | score: score}
  end

  # Gives a fixed bias to populous cities
  defp pop_factor(%Value{population: population}) do
    population = String.to_integer(population)

    if population > 100_000 do
      1.25
    else
      1
    end
  end

  # Gives a fixed bias to nearby cities
  defp dist_factor(%Value{latitude: lat, longitude: long}, target_lat, target_long) do
    dist =
      approximate_dist(
        String.to_float(lat),
        String.to_float(long),
        target_lat,
        target_long
      )

    cond do
      dist < 50 -> 1.25
      dist < 250 -> 1.1
      true -> 1
    end
  end

  # Get the jaro-winkler distance
  defp score_jaro(query, suggestion) do
    String.jaro_distance(query, suggestion.name)
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
