defmodule DdogTest do
  use ExUnit.Case
  use PropCheck
  alias Ddog.Helper

  property "convert a list to string", [:verbose] do
    forall x <- non_empty(char_list()) do
      Helper.build_query(x) == join(x)
    end
  end

  def join(param) do
    build(param)
  end

  def build([head | []]) do
    list =
      case is_list(head) and length(head) <= 1 do
        true -> head |> hd
        false -> head
      end

    cond do
      is_list(list) ->
        Enum.map_join(list, fn x -> "#{x}" end)

      true ->
        "#{list}"
    end
  end

  def build([[] | tail]) do
    list = tail |> List.flatten()

    cond do
      length(list) == 0 ->
        ""

      true ->
        list |> Enum.map_join(fn x -> x end)
    end
  end

  def build(param) when is_list(param) do
    param
    |> List.flatten()
    |> Enum.reduce(fn h, acc ->
      cond do
        is_integer(h) and is_list(h) ->
          h |> List.flatten() |> Enum.map_join(fn x -> "#{acc} #{to_string(x)}" end)

        is_list(h) ->
          h |> List.flatten() |> Enum.map_join(fn x -> "#{acc} #{x}" end)

        true ->
          "#{acc} #{h}"
      end
    end)
  end
end
