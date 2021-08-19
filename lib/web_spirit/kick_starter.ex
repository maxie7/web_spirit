defmodule WebSpirit.KickStarter do
  use GenServer

  def start do
    IO.puts "Starting the kickstarter..."
    GenServer.start(__MODULE__, :ok, name: __MODULE__)
  end

  def init(:ok) do
    Process.flag(:trap_exit, true)
    IO.puts "Starting the HTTP server..."
    server_pid = spawn(WebSpirit.HttpServer, :start, [4000])
    Process.link(server_pid)
    Process.register(server_pid, :http_server)
    {:ok, server_pid}
  end

  def handle_info({:EXIT, _pid, reason}, _state) do
    IO.puts "HttpServer exited (#{inspect reason})"
    IO.puts "Starting the HTTP server..."
    server_pid = spawn(WebSpirit.HttpServer, :start, [4000])
    Process.link(server_pid)
    Process.register(server_pid, :http_server)
    {:noreply, server_pid}
  end

end
