defmodule Suggestions.Util.Levenshtein do
  @moduledoc"""
  Implements a Levenshtein automata operating on the Trie
  data structure.
  """
  alias Suggestions.Trie.Node

  # Returns values of keys in a Trie where key value `kv'
  # is such that the levenshtein distance between `kv' and `query'
  # is less than `max_cost'.
  def search(%Node{char: :root} = root, query, max_cost) do
    current_row = 0..String.length(query) + 1
    Enum.reduce(
      Enum.map(root.children, fn child_node ->
        search_recursive(child_node, query, current_row, max_cost)
      end), [],
      fn x, acc -> x ++ acc end)
  end

  # Private helper function. Assumes that `previous_row'
  # has been computed.
  defp search_recursive(%Node{value: value} = root, query, previous_row, max_cost) do
    columns = String.length(query)
    init_row = [Enum.at(previous_row, 0) + 1]
    current_row = Enum.reduce( 1..columns, init_row,
      fn x, acc ->
        insert_cost = Enum.at(acc, x - 1) + 1
        delete_cost = Enum.at(previous_row, x) + 1
        replace_cost = if String.at(query, x - 1) != root.char do 
          Enum.at(previous_row, x - 1) + 1
        else
          Enum.at(previous_row, x - 1)
        end
        acc ++ [min(min(insert_cost, delete_cost), replace_cost)]
      end
    )
    
    other_results = if Enum.min(current_row) <= max_cost do
      Enum.reduce(
        Enum.map(root.children, fn child_node ->
          search_recursive(child_node, query, current_row, max_cost)
        end), [],
        fn x, acc -> x ++ acc end)
    else
      []
    end

    if Enum.at(current_row, -1) <= max_cost and value != nil do
      [value | other_results]
    else
      other_results
    end
  end
end
