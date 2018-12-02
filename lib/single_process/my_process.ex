defmodule SingleProcess.MyProcess do
  use Agent
  require Logger

  def start_link(_args) do
    Agent.start_link(fn -> %{} end, name: :flags)
  end

  def start() do
    # spawn() long running process here
    do_work()
  end

  def running? do
    Agent.get(:flags, fn map -> Map.get(map, :process_running) end)
  end

  def set_running_flag do
    Agent.update(:flags, fn map -> Map.put(map, :process_running, true) end)
  end

  defp broadcast_value(status) do
    Logger.info("Posting Status: #{status}")

    SingleProcessWeb.Endpoint.broadcast!("room:notification", "new_msg", %{
      uid: 1,
      body: status
    })
  end

  defp do_work do
    Enum.take_every(0..100, 20)
    |> Enum.each(fn value ->
      broadcast_value(value)
      :timer.sleep(1000)
    end)
  end
end
