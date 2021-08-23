defmodule WebSpirit do
  use Application

  def start(_type, _args) do
    IO.puts "Starting the application..."
    WebSpirit.Supervisor.start_link()
  end
end
