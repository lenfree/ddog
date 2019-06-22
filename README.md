# Ddog

Unofficial Elixir package to manage Datadog resources.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ddog` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ddog, "~> 0.1.0"}
  ]
end
```

Add below to config.exs:

```elixir
config :ddog,
  monitor_url: "https://api.datadoghq.com/api/v1/monitor",
  monitor_search_url: "https://api.datadoghq.com/api/v1/monitor/search",
  monitor_downtime_url: "https://api.datadoghq.com/api/v1/downtime",
  monitor_cancel_downtime_byscope_url: "https://api.datadoghq.com/api/v1/downtime/cancel/by_scope"
```

Export Datadog api and app key:

```bash
$ export DATADOG_API_KEY=<key>
$ export DATADOG_APP_KEY=<key>
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ddog](https://hexdocs.pm/ddog).

## TBD

1. Add tests
2. Configure CI
3. Add examples