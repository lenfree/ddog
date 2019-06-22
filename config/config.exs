# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config
config :ddog, monitor_url: "https://api.datadoghq.com/api/v1/monitor"
config :ddog, monitor_search_url: "https://api.datadoghq.com/api/v1/monitor/search"
config :ddog, monitor_downtime_url: "https://api.datadoghq.com/api/v1/downtime"

config :ddog,
  monitor_cancel_downtime_byscope_url: "https://api.datadoghq.com/api/v1/downtime/cancel/by_scope"

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :ddog, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:ddog, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"
