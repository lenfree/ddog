defmodule DdogTest do
  use ExUnit.Case
  use PropCheck
  alias Ddog.Helper

  property "convert a list to string", [:verbose] do
    forall x <- non_empty(char_list()) do
      Helper.build_query(x) == join(x)
    end
  end

  def join([head | _tail] = terms) when length(terms) <= 1 do
    cond do
      is_integer(head) ->
        head |> to_string

      is_list(head) ->
        head
        |> List.flatten()
        |> Enum.join(" ")
    end
  end

  def join(terms) do
    List.flatten(terms)
    |> Enum.join(" ")
  end
end
