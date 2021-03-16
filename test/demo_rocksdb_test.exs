defmodule DemoRocksdbTest do
  use ExUnit.Case
  doctest DemoRocksdb

  test "greets the world" do
    assert DemoRocksdb.hello() == :world
  end
end
