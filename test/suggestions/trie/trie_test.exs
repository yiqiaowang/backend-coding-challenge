defmodule Suggestions.TrieTest do
  use ExUnit.Case, async: true

  alias Suggestions.Trie
  alias Suggestions.Trie.Node
  alias Suggestions.Trie.Value

  setup do
    a = %Value{name: "a", population: 99}
    ab = %Value{name: "ab", population: 10}
    { :ok,
      a: a,
      ab: ab }
  end

  test "construct empty trie" do
    assert Trie.new == %Node{char: :root, children: [], value: nil}
  end

  describe "insert to trie" do
    test "a one character string", context do
      assert Trie.insert(Trie.new, "a", context[:a]) ==
        %Node{char: :root, children: [
          %Node{char: "a", children: [], value: context[:a]}
        ], value: nil}
    end

    test "a word with common letter as prefix", context do
      assert Trie.insert(Trie.insert(Trie.new, "a", context[:a]), "ab", context[:ab]) ==
        %Node{char: :root, children: [
          %Node{char: "a", children: [
            %Node{char: "b", children: [], value: context[:ab]},
          ], value: context[:a]}
        ], value: nil}
    end

    test "a word with common word as prefix", context do
      assert Trie.insert(Trie.insert(Trie.new, "ab", context[:a]), "abc", context[:ab]) ==
        %Node{char: :root, children: [
          %Node{char: "a", children: [
            %Node{char: "b", children: [
              %Node{char: "c", children: [], value: context[:ab]},
            ], value: context[:a]},
          ], value: nil}
        ], value: nil}
    end

    test "two strings with different prefixes", context do
      assert Trie.insert(Trie.insert(Trie.new, "ab", context[:a]), "xy", context[:ab]) ==
        %Node{char: :root, children: [
          %Node{char: "x", children: [
            %Node{char: "y", children: [], value: context[:ab]}
          ], value: nil},
          %Node{char: "a", children: [
            %Node{char: "b", children: [], value: context[:a]}
          ], value: nil}
        ], value: nil}
    end

    test "two strings with different suffixes", context do
      assert Trie.insert(Trie.insert(Trie.new, "ab", context[:a]), "ac", context[:ab]) ==
        %Node{char: :root, children: [
          %Node{char: "a", children: [
            %Node{char: "c", children: [], value: context[:ab]},
            %Node{char: "b", children: [], value: context[:a]}
          ], value: nil}
        ], value: nil}
    end
  end

  describe "lookup in trie" do
    test "with valid key terminating at internal node", context do
      assert Trie.get(Trie.insert(Trie.insert(Trie.new, "a", context[:a]), "ab", context[:ab]), "a") == context[:a]
    end

    test "with valid key terminating at leaf", context do
      assert Trie.get(Trie.insert(Trie.insert(Trie.new, "a", context[:a]), "aab", context[:ab]), "aab") == context[:ab]
    end

    test "with invalid key", context do
      assert Trie.get(Trie.insert(Trie.insert(Trie.new, "a", context[:a]), "ab", context[:ab]), "aa") == nil
    end

    test "with empty key", context do
      assert Trie.get(Trie.insert(Trie.insert(Trie.new, "a", context[:a]), "ab", context[:ab]), "") == nil
    end

    test "containing different suffixes", context do
      assert Trie.get(Trie.insert(Trie.insert(Trie.new, "ab", context[:a]), "ac", context[:ab]), "ab") == context[:a]
      assert Trie.get(Trie.insert(Trie.insert(Trie.new, "ab", context[:a]), "ac", context[:ab]), "ac") == context[:ab]
    end

    test "containing different prefixes", context do
      assert Trie.get(Trie.insert(Trie.insert(Trie.new, "ab", context[:a]), "ac", context[:ab]), "ab") == context[:a]
      assert Trie.get(Trie.insert(Trie.insert(Trie.new, "xy", context[:a]), "ij", context[:ab]), "ij") == context[:ab]
    end
  end
end
