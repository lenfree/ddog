defmodule Ddog.Helper do
  @doc """
  Accepts list of tags passed and return a list of tags
  for Datadog search.

  Returns `tag1 tag2 tag3`

    ## Examples

        iex> build_query(["tag1", "tag2", "tag3"])
        "tag1 tag2 tag3"


  """
  def build_query(param) when is_list(param) do
    param
    |> Enum.reduce(fn x, acc -> "#{x} #{acc}" end)
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

  defp handle_response({:ok, %{status_code: 200, body: body}}) do
    {:ok, body}
  end

  defp handle_response({:ok, %{status_code: 400, body: body}}) do
    {:ok, body}
  end

  defp handle_response({_, {:error, body}, %{status_code: _, body: body}}) do
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

  defp add_auth(url, query \\ %{}) do
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
