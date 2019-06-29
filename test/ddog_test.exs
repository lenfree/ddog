defmodule DdogTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Ddog.Helper

  require IEx

  describe "pass a list of ascii input returns a string with a ' ' in between each element" do
    property "list of strings input joins as a string should be equal to build_query/1 output" do
      check all str <- list_of(string(:ascii)) do
        assert Helper.build_query(str) == str
        |> Enum.filter(&String.length(&1) > 0)
        |> List.flatten()
        |> Enum.join(" ")
        end
    end
  end
end
