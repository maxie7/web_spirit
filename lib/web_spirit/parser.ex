defmodule WebSpirit.Parser do

  alias WebSpirit.Conv, as: Conv

  def parse(request) do
    [method, path, _] =
      request
      |> String.split("\n")
      |> List.first
      |> String.split(" ")
    %Conv{
      method: method,
      path: path
    }
  end
end

