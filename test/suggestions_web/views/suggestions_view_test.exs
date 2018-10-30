defmodule SuggestionsWeb.SuggestionsViewTest do
  use SuggestionsWeb.ConnCase, async: true

  # Bring render/3 and render_to_string/3 for testing custom views
  import Phoenix.View

  setup do
    suggestions = [
      %Suggestions.Trie.Value{
        key: "logan",
        latitude: "41.73549",
        longitude: "-111.83439",
        name: "Logan, US",
        population: "48174",
        score: 2.5185185185185185
      },
      %Suggestions.Trie.Value{
        key: "logansport",
        latitude: "40.75448",
        longitude: "-86.35667",
        name: "Logansport, US",
        population: "18396",
        score: 2.5714285714285715
      },
      %Suggestions.Trie.Value{
        key: "loganville",
        latitude: "33.839",
        longitude: "-83.90074",
        name: "Loganville, US",
        population: "10458",
        score: 1.4920634920634921
      }
    ]

    json = [
      %Suggestions.Trie.Value{
        key: "logan",
        latitude: "41.73549",
        longitude: "-111.83439",
        name: "Logan, US",
        population: "48174",
        score: 2.5185185185185185
      },
      %Suggestions.Trie.Value{
        key: "logansport",
        latitude: "40.75448",
        longitude: "-86.35667",
        name: "Logansport, US",
        population: "18396",
        score: 2.5714285714285715
      },
      %Suggestions.Trie.Value{
        key: "loganville",
        latitude: "33.839",
        longitude: "-83.90074",
        name: "Loganville, US",
        population: "10458",
        score: 1.4920634920634921
      }
    ]

    {:ok, suggestions: suggestions, json: json}
  end

  describe "renders index.json correctly" do
    test "by stripping unused fields", context do
      assert List.first(
               render(SuggestionsWeb.SuggestionView, "index.json",
                 suggestions: context[:suggestions]
               ).suggestions
             ) == %{
               latitude: "40.75448",
               longitude: "-86.35667",
               name: "Logansport, US",
               score: 1.0
             }
    end

    test "by normalizing scores", context do
      assert Enum.all?(
               Enum.map(
                 render(SuggestionsWeb.SuggestionView, "index.json",
                   suggestions: context[:suggestions]
                 ).suggestions,
                 fn x -> x.score end
               ),
               fn x -> x >= 0 and x <= 1 end
             ) == true
    end

    test "by removing poorly scored suggestions", context do
      assert Enum.any?(
               Enum.map(
                 render(SuggestionsWeb.SuggestionView, "index.json",
                   suggestions: context[:suggestions]
                 ).suggestions,
                 fn x -> x.name end
               ),
               fn x -> x == "Loganville, US" end
             ) == false
    end
  end
end
