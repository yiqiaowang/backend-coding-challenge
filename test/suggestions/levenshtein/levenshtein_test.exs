defmodule Suggestions.LevenshteinTest do
  use ExUnit.Case, async: true

  alias Suggestions.Trie
  alias Suggestions.Trie.Value

  alias Suggestions.Util.Levenshtein

  setup do
    a = %Value{name: "a", population: 99}
    ab = %Value{name: "ab", population: 10}
    trie = Trie.insert(Trie.insert(Trie.new(), "lima", a), "limor", ab)
    {:ok, a: a, ab: ab, trie: trie}
  end

  describe "levenshtein automata" do
    test "finds exact match when max_cost is zero", context do
      assert Levenshtein.search(context[:trie], "lima", 0) == [context[:a]]
    end

    test "can find matching words when max_cost is one", context do
      assert Levenshtein.search(context[:trie], "lime", 1) == [context[:a]]
    end

    test "can find matching words when max_cost is two", context do
      assert Levenshtein.search(context[:trie], "lqmer", 2) == [context[:ab]]
    end

    test "can find all words when max_cost is five", context do
      assert Levenshtein.search(context[:trie], "asdf", 5) == [context[:a], context[:ab]]
    end
  end
end
