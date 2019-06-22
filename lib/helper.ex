defmodule Ddog.Helper do
  # This accepts list of tags passed and returns a
  # Datadog search query format of "tag1 tag2 tag3"
  def build_query(param) when is_list(param) do
    param
    |> Enum.reduce(fn x, acc -> "#{x} #{acc}" end)
  end

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
    {:ok, body}
  end

  def handle_response({_, {:error, body}, %{status_code: _, body: body}}) do
    {:error, body}
  end

  @api_key Application.get_env(:ddog, :api_key)
  @app_key Application.get_env(:ddog, :app_key)
  def auth do
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

  def check_creds do
    {:ok, %{"api_key" => @api_key, "application_key" => @app_key}}
  end
end
