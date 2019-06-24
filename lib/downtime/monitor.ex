defmodule Ddog.Monitor do
  alias HTTPoison
  alias Ddog.Helper
  alias Ddog.Monitor.Downtime

  defp headers do
    [{"Content-type", "application/json"}]
  end

  @doc """
  Call receives an action atom to manage Datadog monitor and returns
  {:ok, HTTPoison.Response.body} when successful and
  {:error, HTTPoison.Response.Body} when error. Possible values are:
  :list_all which returns all monitors, :search which accepts a list of tags
  and returns a list of monitors that matches the tags, :set_monitor_downtime
  which accepts SetMonitorDowntime struct and set monitor downtime,
  :cancel_monitor_downtime_by_scope which accepts a scope to cancel
  monitor downtime.

  Returns `{:ok, %HTTPoison.Response.Body{}}`.

    ## Examples


        iex> Monitor.call(:list_all)
        {:ok, %HTTPoison.Response.Body{}}


        iex> Monitor.call(
          :search,
          %{
            query: Ddog.Helper.build_query("env:test localhost")
          })
        {:ok, %HTTPoison.Response.Body{}}

        iex> Monitor.call(
          :set_monitor_downtime,
          %Ddog.Monitor.Downtime{
              monitor_tags: Ddog.Helper.build_query("env:test localhost"),
              scope: "env:test",
              end: end_downtime,
              message: "scheduled upgrade"
          })
        {:ok, %HTTPoison.Response.Body{}}

        iex> Monitor.call(
          :cancel_monitor_downtime_by_scope,
          %Ddog.Monitor.Downtime{
              scope: "env:test"
          })
        {:ok, %HTTPoison.Response.Body{}}
  """
  def call(:list_all = action) do
    action
    |> dd_url()
    |> HTTPoison.get(headers())
    |> Helper.handle_response()
  end

  def call(:search = action, %{query: _tag} = tags) do
    action
    |> dd_url(tags)
    |> HTTPoison.get(headers())
    |> Helper.handle_response()
  end

  def call(:set_monitor_downtime = action, %Downtime{} = body) do
    action
    |> dd_url()
    |> HTTPoison.post(body |> Poison.encode!(), headers())
    |> Helper.handle_response()
  end

  def call(:cancel_monitor_downtime_by_scope = action, %Downtime{} = body) do
    action
    |> dd_url()
    |> HTTPoison.post(body |> Poison.encode!(), headers())
    |> Helper.handle_response()
  end

  @monitor_url Application.get_env(:ddog, :monitor_url)
  defp dd_url(:list_all) do
    @monitor_url
    |> Helper.add_auth()
  end

  @monitor_downtime_url Application.get_env(:ddog, :monitor_downtime_url)
  defp dd_url(:set_monitor_downtime) do
    @monitor_downtime_url
    |> Helper.add_auth()
  end

  @monitor_cancel_downtime_byscope_url Application.get_env(
                                         :ddog,
                                         :monitor_cancel_downtime_byscope_url
                                       )
  defp dd_url(:cancel_monitor_downtime_by_scope) do
    @monitor_cancel_downtime_byscope_url
    |> Helper.add_auth()
  end

  @monitor_search_url Application.get_env(:ddog, :monitor_search_url)
  defp dd_url(:search, %{query: _tag} = tags) do
    @monitor_search_url
    |> Helper.add_auth(tags)
  end

  @doc """
  Accepts a list of map of monitors and returns a list of map of id, name,
  metrics, status and tags.

  Returns `[%{
        id: id,
        name: "name",
        metrics: "metrics",
        status: "status",
        tags: ["tags"],
        scopes: ["scopes"]
  }`

    ## Examples


        iex> Monitor.get_monitor_details(%{"monitors" => [{
            "type": "service check",
            "tags": [
              "monitor_id:host_is_up",
              "env:test",
            ],
            "status": "OK",
            "scopes": [
              "env:test"
            ],
            "name": "localhost",
            "metrics": [
              "datadog.agent.up"
            ],
            "classification": "host",
            ...
            ...
            ...}]
        [{
          id: 1,
          name: "localhost",
          metrics: "datadog.agent.up",
          status: "OK",
          tags: ["env:test", "monitor_id:host_is_up"],
          scopes: ["env:test"]
        }]

  """
  def get_monitor_details(%{"monitors" => monitors}) when is_list(monitors) do
    monitors
    |> List.flatten()
    |> Enum.map(
      &%{
        id: &1["id"],
        name: &1["name"],
        metrics: &1["metrics"],
        status: &1["status"],
        tags: &1["tags"],
        scopes: &1["scopes"]
      }
    )
  end
end
