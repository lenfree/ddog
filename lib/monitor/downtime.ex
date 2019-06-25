defmodule Ddog.Monitor.Downtime do
  # TODO: Improve docs.
  @doc """
  A struct describing a monitor downtime.
  """
  defstruct monitor_tags: nil, scope: nil, end: nil, message: nil
end
