defmodule Suggestions.Trie.Value do
  @moduledoc """
  Module providing a struct to hold information regarding
  cities.

  Additionally provides a helper function to construct a Value
  struct from a list of data items.
  """
  defstruct name: "",
            latitude: 0.0,
            longitude: 0.0,
            population: 0,
            score: 0

  def from_list(index_map, list) do
    %__MODULE__{
      name: "#{Enum.at(list, index_map.name)}, #{Enum.at(list, index_map.country)}",
      latitude: Enum.at(list, index_map.latitude),
      longitude: Enum.at(list, index_map.longitude),
      population: Enum.at(list, index_map.population)
    }
  end
end
