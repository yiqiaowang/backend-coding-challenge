defmodule Suggestions.Trie do
  @moduledoc """
  This module implements a prefix trie
  """
  alias Suggestions.Trie.Node
  alias Suggestions.Trie.Value

  # Public
  def new do
    new_node(:root)
  end

  def insert(%Node{} = root, string, %Value{} = value) do
    {head, tail} = String.split_at(string, 1)
    {match, other} = extract_matching_child(root, head)

    if not Enum.empty?(match) and Enum.count(match) == 1 do
      # Traverse down tree as long as prefix matches
      case tail do
        "" -> add_child(root, %Node{Enum.at(match, 0) | value: value}, other)
        _ -> add_child(root, insert(Enum.at(match, 0), tail, value), other)
      end
    else
      # Append new nodes for remaining characters
      case tail do
        "" -> add_child(root, new_node(head, value))
        _ -> insert(add_child(root, new_node(head)), string, value)
      end
    end
  end

  def get(%Node{} = root, string) do
    {head, tail} = String.split_at(string, 1)
    {match, _} = extract_matching_child(root, head)

    if not Enum.empty?(match) and Enum.count(match) == 1 do
      case tail do
        "" -> Enum.at(match, 0).value
        _ -> get(Enum.at(match, 0), tail)
      end
    else
      nil
    end
  end

  # Private
  defp new_node(char, value \\ nil) do
    %Node{char: char, value: value}
  end

  defp extract_matching_child(%Node{children: children}, char) do
    {Enum.filter(children, fn x -> x.char == char end),
     Enum.filter(children, fn x -> x.char != char end)}
  end

  defp add_child(root, new_child) do
    %{root | children: [new_child | root.children]}
  end

  defp add_child(root, new_child, children) do
    %{root | children: [new_child | children]}
  end
end
