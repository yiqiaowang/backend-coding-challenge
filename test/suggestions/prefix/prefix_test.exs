defmodule Suggestions.PrefixTest do
  use ExUnit.Case, async: true

  alias Suggestions.Trie
  alias Suggestions.Trie.Value

  alias Suggestions.Util.Prefix

  setup do
    a = %Value{name: "a", population: 99}
    ab = %Value{name: "ab", population: 10}
    trie = Trie.insert(Trie.insert(Trie.new(), "lima", a), "limor", ab)
    {:ok, a: a, ab: ab, trie: trie}
  end

  describe "prefix search" do
    test "finds exact match", context do
      assert Enum.find(Prefix.search(context[:trie], "lima"), fn x -> x.name == "a" end) ==
               context[:a]
    end
  end
end
