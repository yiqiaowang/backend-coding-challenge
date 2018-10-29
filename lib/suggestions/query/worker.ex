defmodule Suggestions.Query.Worker do
  @moduledoc """
  GenServer that provides a list of city names that
  are similar to the query.
  """
  use GenServer
  require Logger

  alias Suggestions.Trie
  alias Suggestions.Trie.Value
  alias Suggestions.Util.DataLoader
  alias Suggestions.Util.Levenshtein
  alias Suggestions.Util.Scorer

  # Client API
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def query(querystring) do
    GenServer.call(__MODULE__, {:query, querystring})
  end

  def query(querystring, latitude, longitude) do
    GenServer.call(__MODULE__, {:query_location, querystring, latitude, longitude})
  end

  # Server API
  def init(:ok) do
    {:ok, %{data: construct_trie(load_data())}}
  end

  def handle_call({:query, querystring}, _from, state) do
    lowercase_qs = String.downcase(querystring)

    Logger.info("Received query for #{lowercase_qs}")

    start_time = System.system_time(:millisecond)
    reply = Scorer.assign_scores(
      Levenshtein.search(
        state.data, lowercase_qs, Suggestions.levenshtein_cost()
      ))
    end_time = System.system_time(:millisecond)

    Logger.info("Processed results in #{end_time - start_time} ms")

    {:reply, reply, state}
  end

  def handle_call({:query_location, querystring, latitude, longitude}, _from, state) do
    lowercase_qs = String.downcase(querystring)

    Logger.info("Received query for #{lowercase_qs} with location [#{latitude}, #{longitude}]")

    start_time = System.system_time(:millisecond)
    reply = Scorer.assign_scores(
      Levenshtein.search(
        state.data, lowercase_qs, Suggestions.levenshtein_cost()
      ),
      %{latitude: latitude, longitude: longitude})
    end_time = System.system_time(:millisecond)

    Logger.info("Processed results in #{end_time - start_time} ms")

    {:reply, reply, state}
  end

  # Private 
  defp construct_trie(data_stream) do
    Enum.reduce(data_stream, Trie.new(), fn x, acc ->
      {status, key, value} = format_entry(x)

      case status do
        :ok -> Trie.insert(acc, key, value)
        :error -> acc
      end
    end)
  end

  defp format_entry({:ok, data_entry}) do
    {:ok, String.downcase(Enum.at(data_entry, 1)),
     Value.from_list(
       %{name: 1, latitude: 4, longitude: 5, country: 8, population: 14},
       data_entry
     )}
  end

  defp format_entry({:error, msg}) do
    Logger.error(msg)
    {:error, nil, nil}
  end

  defp load_data do
    {:ok, base_dir} = File.cwd()
    DataLoader.load_data("#{base_dir}/data/#{Suggestions.city_data()}", ?\t)
  end
end
