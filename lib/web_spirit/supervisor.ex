defmodule WebSpirit.Supervisor do
  use Supervisor

  def start_link do
    IO.puts "Starting the top level supervisor..."
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    children = [
      WebSpirit.KickStarter,
      WebSpirit.ServicesSupervisor
    ]

    Supervisor.init(children, strategy: :one_for_one)
  end
end
