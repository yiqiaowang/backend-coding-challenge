defmodule Suggestions.ScorerTest do
  use ExUnit.Case, async: true

  alias Suggestions.Util.Scorer

  setup do
    location = %{latitude: 50.0, longitude: -122.0}
    query = "Abbotsford"

    suggestions = [
      %Suggestions.Trie.Value{
        latitude: "49.05798",
        longitude: "-122.25257",
        name: "Abbotsford, CA",
        key: "abbotsford",
        population: "151683"
      }
    ]

    {:ok, query: query, suggestions: suggestions, location: location}
  end

  describe "gives score to suggestions" do
    test "without location parameters", context do
      assert Scorer.assign_scores(
               context[:query],
               context[:suggestions]
             ) == Enum.map(context[:suggestions], fn x -> %{x | score: 1.130952380952381} end)
    end

    test "with location parameters", context do
      assert Scorer.assign_scores(
               context[:query],
               context[:suggestions],
               context[:location]
             ) == Enum.map(context[:suggestions], fn x -> %{x | score: 1.244047619047619} end)
    end
  end

  test "gives reasonable distance approximation" do
    assert Scorer.approximate_dist(49.5, -122, 49.05798, -122.25257) < 100
  end
end
