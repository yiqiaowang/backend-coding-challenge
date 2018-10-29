defmodule Suggestions.ScorerTest do
  use ExUnit.Case, async: true

  alias Suggestions.Util.Scorer

  setup do
    location = %{latitude: 50.0, longitude: -120.0}

    suggestions = [
      %Suggestions.Trie.Value{
        latitude: "49.05798",
        longitude: "-122.25257",
        name: "Abbotsford, CA",
        population: "151683"
      }
    ]

    {:ok, suggestions: suggestions, location: location}
  end

  describe "gives score to suggestions" do
    test "without location parameters", context do
      assert Scorer.assign_scores(context[:suggestions]) ==
               Enum.map(context[:suggestions], fn x -> %{x | score: 0.5} end)
    end

    test "with location parameters", context do
      assert Scorer.assign_scores(context[:suggestions], context[:location]) ==
               Enum.map(context[:suggestions], fn x -> %{x | score: 0.75} end)
    end
  end
end
