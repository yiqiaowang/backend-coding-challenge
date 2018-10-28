defmodule Suggestions.Trie.Node do
  @moduledoc """
  Stuct representing a trie node.
  """
  defstruct char: nil, children: [], value: nil
end
