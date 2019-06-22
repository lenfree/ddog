defmodule Ddog.Monitor do
  alias HTTPoison
  alias Ddog.Helper

  defp headers do
    [{"Content-type", "application/json"}]
  end

  def call(:list_all = action) do
    action
    |> dd_url()
    |> HTTPoison.get(headers())
    |> Helper.handle_response()
  end

  def call(:search = action, query) do
    action
    |> dd_url(query)
    |> HTTPoison.get(headers())
    |> Helper.handle_response()
  end

  def call(:set_monitor_downtime = action, body) do
    action
    |> dd_url()
    |> HTTPoison.post(body |> Poison.encode!(), headers())
    |> Helper.handle_response()
  end

  def call(:cancel_monitor_downtime_by_scope = action, body) do
    action
    |> dd_url()
    |> HTTPoison.post(body |> Poison.encode!(), headers())
    |> Helper.handle_response()
  end

  @monitor_url Application.get_env(:ddog, :monitor_url)
  def dd_url(:list_all) do
    @monitor_url
    |> Helper.add_auth()
  end

  @monitor_downtime_url Application.get_env(:ddog, :monitor_downtime_url)
  def dd_url(:set_monitor_downtime) do
    @monitor_downtime_url
    |> Helper.add_auth()
  end

  @monitor_cancel_downtime_byscope_url Application.get_env(
                                         :ddog,
                                         :monitor_cancel_downtime_byscope_url
                                       )
  def dd_url(:cancel_monitor_downtime_by_scope) do
    @monitor_cancel_downtime_byscope_url
    |> Helper.add_auth()
  end

  @monitor_search_url Application.get_env(:ddog, :monitor_search_url)
  def dd_url(:search, query) do
    @monitor_search_url
    |> Helper.add_auth(query)
  end

  def get_monitor_details(%{"monitors" => monitors}) when is_map(monitors) do
    monitors
    |> List.flatten()
    |> Enum.map(
      &%{
        id: &1["id"],
        name: &1["name"],
        metrics: &1["metrics"],
        status: &1["status"],
        tags: &1["tags"]
      }
    )
  end
end
