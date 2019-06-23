defmodule Ddog.SetMonitorDowntime do
  # TODO: Improve docs.
  @doc """
  A struct describing how to set a monitor downtime.
  """
  defstruct monitor_tags: nil, scope: nil, end: nil, message: nil
end

defmodule Ddog.CancelMonitorDowntime do
  @doc """
  A struct describing how to cancel a monitor downtime.
  """
  defstruct scope: nil
end
