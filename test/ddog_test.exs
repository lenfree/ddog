defmodule DdogTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  alias Ddog.Helper

  require IEx

  describe "build_query/1" do
    property "pass a list of ascii input returns a string with a ' ' in between each element" do
            check all str <- list_of(string(:ascii)) do
              assert Helper.build_query(str) == str
              |> Enum.filter(fn x -> String.length(x) > 0 end)
              |> List.flatten()
              |> Enum.join(" ")
      end
    end
  end
end
