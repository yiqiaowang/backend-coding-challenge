defmodule Suggestions.Util.DataLoader do
  @moduledoc """
  Loads the raw TSV data into a stream.
  """
  def load_data(path, separator) do
    path |> File.stream!() |> CSV.decode(separator: separator)
  end
end
