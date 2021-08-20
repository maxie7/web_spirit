defmodule WebSpirit.SensorServer do

  @name :sensor_server
  @refresh_interval :timer.minutes(60) # :timer.seconds(5)

  use GenServer

  # Client Interface

  def start_link(_arg) do
    IO.puts "Starting the sensor server..."
    GenServer.start_link(__MODULE__, %{}, name: @name)
  end

  def get_sensor_data do
    GenServer.call @name, :get_sensor_data
  end

  # Server Callbacks

  def init(_state) do
    initial_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:ok, initial_state}
  end

  def handle_info(:refresh, _state) do
    IO.puts "Refreshing the cache..."
    new_state = run_tasks_to_get_sensor_data()
    schedule_refresh()
    {:noreply, new_state}
  end

  defp schedule_refresh do
    Process.send_after(self(), :refresh, @refresh_interval)
  end

  def handle_call(:get_sensor_data, _from, state) do
    {:reply, state, state}
  end

  defp run_tasks_to_get_sensor_data do
    IO.puts "Running tasks to get sensor data..."

    task_struct = Task.async(fn -> WebSpirit.Tracker.get_location("bigfoot") end)

    snapshots =
      ["cam-1", "cam-2", "cam-3"]
      |> Enum.map(&Task.async(fn -> WebSpirit.VideoCam.get_snapshot(&1) end))
      |> Enum.map(&Task.await(&1))

    where_is_bigfoot = Task.await(task_struct)

    %{snapshots: snapshots, location: where_is_bigfoot}
  end
end
