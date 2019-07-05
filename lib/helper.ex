defmodule Ddog.Helper do
  @doc """
  Accepts list of tags passed and return a list of tags
  for Datadog search.

  Returns `tag1 tag2 tag3`

    ## Examples

        iex> build_query(["tag1", "tag2", "tag3"])
        "tag1 tag2 tag3"


  """
  def build_query(terms) when is_binary(terms) do
    terms
  end

  def build_query(terms) when is_integer(terms) do
    terms |> to_string
  end

  def build_query(terms) when is_list(terms) do
    terms
    |> Enum.reject(&(check_length(&1) == 0))
    |> build_query("")
  end

  def build_query(term) when is_atom(term) do
    "#{term}"
  end

  def build_query([]) do
    ""
  end

  def check_length(term) when is_integer(term) do
    true
  end

  def check_length(term) when is_binary(term) do
    String.length(term)
  end

  def check_length(term) when is_atom(term) do
    term |> Atom.to_string() |> check_length
  end

  def build_query([], acc) do
    acc
  end

  def build_query([head | []], acc) do
    cond do
      is_list(head) ->
        [h | t] = head
        build_query([t], "#{acc} #{h}")

      is_binary(head) and String.length(head) == 0 ->
        ""

      is_binary(head) and String.length(acc) > 0 ->
        "#{acc} #{head}"

      is_integer(head) and String.length(acc) > 0 ->
        "#{acc} #{to_string(head)}"

      is_atom(head) and String.length(acc) > 0 ->
        "#{acc} #{head}"

      true ->
        "#{head}"
    end
  end

  def build_query([head | tail], acc) do
    require IEx

    cond do
      is_binary(head) and String.length(acc) > 0 ->
        build_query(tail, "#{acc} #{head}")

      is_integer(head) and String.length(acc) > 0 ->
        build_query(tail, "#{acc} #{to_string(head)}")

      is_atom(head) and String.length(acc) > 0 ->
        build_query(tail, "#{acc} #{head}")

      is_binary(head) ->
        build_query(tail, "#{head}")

      is_integer(head) ->
        build_query(tail, "#{to_string(head)}")

      is_atom(head) ->
        build_query(tail, "#{head}")

      Enum.empty?(head) ->
        build_query(tail, "#{acc}")

      String.length(head) == 0 ->
        build_query(tail, "#{acc}")

      true ->
        build_query(tail, "#{head}")
    end
  end

  @doc """
  Accepts a list of monitors and return a prettified string. When argument
  is of type map, it returns a prettified json string.
  """
  def prettify(monitors) when is_list(monitors) do
    Poison.encode!(%{monitors: monitors}, pretty: true)
  end

  def prettify(monitor) when is_map(monitor) do
    Poison.encode!(%{monitor: monitor}, pretty: true)
  end

  def handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  def handle_response({:ok, %{status_code: 400, body: body}}) do
    {:error, body}
  end

  def handle_response({:ok, %{status_code: 404, body: body}}) do
    {:error, body}
  end

  def handle_response({:ok, %{status_code: 403}}) do
    {:error, "invalid API/APP token"}
  end

  def handle_response({_, {:error, body}, %{status_code: _, body: body}}) do
    {:error, body}
  end

  defp auth do
    case check_creds() do
      {:error, message} ->
        raise message

      {:ok, creds} ->
        creds
    end
  end

  def add_auth(url, query \\ %{}) do
    path =
      auth()
      |> Enum.into(query)
      |> URI.encode_query()

    "#{url}?#{path}"
  end

  defp check_creds do
    cond do
      System.get_env("DATADOG_API_KEY") == nil ->
        {:error, "ENV variable not set: DATADOG_API_KEY"}

      System.get_env("DATADOG_APP_KEY") == nil ->
        {:error, "ENV variable not set: DATADOG_APP_KEY"}

      true ->
        {:ok,
         %{
           "api_key" => System.get_env("DATADOG_API_KEY"),
           "application_key" => System.get_env("DATADOG_APP_KEY")
         }}
    end
  end
end
