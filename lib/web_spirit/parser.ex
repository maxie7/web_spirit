defmodule WebSpirit.Parser do

  alias WebSpirit.Conv, as: Conv

  def parse(request) do
    [top, params_string] = String.split(request, "\n\n")

    [method, path, _] =
      top
      |> String.split("\n")
      |> List.first
      |> String.split(" ")
    %Conv{
      method: method,
      path: path
    }
  end
end

