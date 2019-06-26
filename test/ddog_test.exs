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

  test "build_query/1 with an atom input" do
    term = ExUnitProperties.pick(StreamData.atom(:alphanumeric))
    assert Helper.build_query(term) == ":" <> to_string(term)
  end

  test "build_query/1 with a string input" do
    term = ExUnitProperties.pick(StreamData.string(:alphanumeric))
    assert Helper.build_query(term) == term
  end

  test "build_query/1 with an integer input" do
    term = ExUnitProperties.pick(StreamData.integer())
    assert Helper.build_query(term) == Integer.to_string(term)
  end
end
