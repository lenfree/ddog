defmodule DdogTest do
  use ExUnit.Case
  alias Ddog.Helper
  require ExUnitProperties

  require IEx

  test "build_query/1 with ascii input" do
    terms =
      ExUnitProperties.gen all term <- StreamData.list_of(StreamData.string(:ascii)) do
        term
      end
      |> Enum.take(30)

    assert Helper.build_query(terms) == terms |> List.flatten() |> Enum.join(" ")
  end

  test "build_query/1 with integers input" do
    terms =
      ExUnitProperties.gen all term <- StreamData.list_of(StreamData.integer()) do
        term
      end
      |> Enum.take(30)

    assert Helper.build_query(terms) == terms |> List.flatten() |> Enum.join(" ")
  end
end
