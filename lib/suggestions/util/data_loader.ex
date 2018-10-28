defmodule Suggestions.Util.DataLoader do
  def load_data(path, separator) do
    File.stream!(path) |> CSV.decode(separator: separator)
  end
end
