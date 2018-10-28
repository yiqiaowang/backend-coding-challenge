defmodule Suggestions.WorkerTest do
  use ExUnit.Case, async: true

  alias Suggestions.Query.Worker

  setup do
    # Start the worker process
    Worker.start_link

    abbotsford = [%Suggestions.Trie.Value{
      latitude: "49.05798",
      longitude: "-122.25257",
      name: "Abbotsford, CA",
      population: "151683"
    }]
    { :ok,
      abbotsford: abbotsford }
  end

  describe "suggest appropriate cities" do
    test "on exact lowercase queries", context do
      assert Worker.query("abbotsford") == context[:abbotsford]
    end

    test "on exact uppercased queries", context do
      assert Worker.query("Abbotsford") == context[:abbotsford]
    end

    test "on approximate queries", context do
      assert Worker.query("Abbatsfjord") == context[:abbotsford]
    end
  end

  test "do not suggest on nonsense queries" do
      assert Worker.query("asdfasdfasdf") == []
  end
end
