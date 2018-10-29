defmodule Suggestions.Util.Prefix do
  @moduledoc """
  Implements a prefix search using trie data structure.
  """
  alias Suggestions.Trie.Node

  # Returns values of keys in a Trie where key value `kv'
  # is such that the levenshtein distance between `kv' and `query'
  # is less than `max_cost'.
  def search(%Node{char: :root} = root, query) do
    Enum.reduce(
      Enum.map(
        Enum.filter(root.children, fn x -> x.char == String.at(query, 0) end),
        fn x -> search_recursive(x, query) end),
      [],
      fn x, acc -> x ++ acc end
    )
  end

  # Returns all the nodes that share a common prefix with query
  # returns a tuple with 
  defp search_recursive(%Node{} = root, query) do
    {head, tail} = String.split_at(query, 1)
    cond do
      head == root.char and String.length(tail) == 0 ->
        get_values(root)
      head == root.char ->
        Enum.reduce(
          Enum.map(root.children, fn x -> search_recursive(x, tail) end),
          [],
          fn x, acc -> x ++ acc end)
      true -> get_values(root)
    end
  end

  defp get_values(%Node{} = root) do
    if root.value != nil do
      [%{root.value | is_prefix: 1} | Enum.flat_map(root.children, fn x -> get_values(x) end)]
    else
      Enum.flat_map(root.children, fn x -> get_values(x) end)
    end
  end

  defp get_values(_) do [] end
end
