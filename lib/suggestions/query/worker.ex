defmodule Suggestions.Query.Worker do
  @moduledoc """
  GenServer that provides a list of city names that
  are similar to the query.
  """
  use GenServer

  # Client API
  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def query(querystring) do
    GenServer.call(__MODULE__, {:query, querystring})
  end

  # Server API
  def init(:ok) do
    {:ok, {}}
  end

  def handle_call({:query, querystring}, _from, state) do
    {:reply, "The query was: #{querystring}", state}
  end
end
