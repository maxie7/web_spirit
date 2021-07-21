defmodule WebSpirit.Handler do
  @moduledoc """
    Handles HTTP requests
  """

  alias WebSpirit.Conv
  alias WebSpirit.SpiritController

  @pages_path Path.expand("../../pages", __DIR__)

  import WebSpirit.Plugins, only: [rewrite_path: 1, log: 1, track: 1]
  import WebSpirit.Parser, only: [parse: 1]

  @doc """
    Transforms the request into a response
  """
  def handle(request) do
    request
    |> parse
    |> rewrite_path
    # |> log
    |> route
    |> track
    |> format_response
  end

  def route(%Conv{ method: "GET", path: "/hibernate/" <> time } = conv) do
    time |> String.to_integer |> :timer.sleep
    %{ conv | status: 200, resp_body: "Awake!" }
  end

  def route(%Conv{ method: "GET", path: "/wildthings" } = conv) do
    # Example >>> " %{conv | resp_body: "Bears" " is an alternative to " Map.put(conv, :resp_body, "Bears") "
    %{ conv | status: 200, resp_body: "Bears, Lions, Tigers" }
  end

  def route(%Conv{ method: "GET", path: "/api/bears" } = conv) do
    WebSpirit.Api.BearController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/bears" } = conv) do
    SpiritController.index(conv)
  end

  def route(%Conv{ method: "GET", path: "/bears/" <> id } = conv) do
    params = Map.put(conv.params, "id", id)
    SpiritController.show(conv, params)
  end

  # name=Baloo&type=Brown
  def route(%Conv{ method: "POST", path: "/bears" } = conv) do
    SpiritController.create(conv, conv.params)
  end

  def route(%Conv{ method: "GET", path: "/about" } = conv) do
      @pages_path
      |> Path.join("about.html")
      |> File.read
      |> handle_file(conv)
  end

  def route(%Conv{ path: path } = conv) do
    %{ conv | status: 404 , resp_body: "No #{path} here!" }
  end

  def handle_file({:ok, content}, conv) do
    %{ conv | status: 200, resp_body: content }
  end

  def handle_file({:error, :enoent}, conv) do
    %{ conv | status: 404, resp_body: "File not found!" }
  end

  def handle_file({:error, reason}, conv) do
    %{ conv | status: 500, resp_body: "File error: #{reason}" }
  end

  def format_response(%Conv{} = conv) do
    """
    HTTP/1.1 #{Conv.full_status(conv)}\r
    Content-Type: #{conv.resp_content_type}\r
    Content-Length: #{String.length(conv.resp_body)}\r
    \r
    #{conv.resp_body}
    """
  end

end
