defmodule SingleProcess.MyProcess do
  use GenServer
  require Logger

  # Client API
  def start_link(opts \\ []) do
    IO.inspect(opts)
    GenServer.start_link(__MODULE__, %{}, opts)
  end

  def start() do
    GenServer.call(:my_process, :start)
  end

  def is_running?() do
    GenServer.call(:my_process, :is_running)
  end

  # Server API
  def init(process_map) do
    {:ok, process_map}
  end

  def handle_call(:is_running, _from, process_map) do
    {:reply, Map.get(process_map, :process_running, false), process_map}
  end

  def handle_call(:start, _from, process_map) do
    case Map.get(process_map, :process_running) do
      true ->
        {:reply, process_map, process_map}

      _other ->
        Task.async(&do_work/0)
        updated_process_map = Map.put(process_map, :process_running, true)
        {:reply, updated_process_map, updated_process_map}
    end
  end

  def handle_info(_, process_map) do
    updated_process_map = Map.put(process_map, :process_running, false)
    {:noreply, updated_process_map}
  end

  defp broadcast_value(status) do
    Logger.info("Posting Status: #{status}")

    SingleProcessWeb.Endpoint.broadcast!("room:notification", "new_msg", %{
      uid: 1,
      body: status
    })
  end

  defp do_work do
    Enum.take_every(0..80, 20)
    |> Enum.each(fn value ->
      broadcast_value(value)
      :timer.sleep(1000)
    end)
  end
end
