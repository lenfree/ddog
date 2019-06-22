defmodule DdogTest do
  use ExUnit.Case
  doctest Ddog

  test "greets the world" do
    assert Ddog.hello() == :world
  end
end
