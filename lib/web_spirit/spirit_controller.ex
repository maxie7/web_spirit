defmodule WebSpirit.SpiritController do

  alias WebSpirit.Wildthings
  alias WebSpirit.Bear

  defp bear_item(bear) do
    "<li>#{bear.name} - #{bear.type}</li>"
  end

  def index(conv) do
    items =
      Wildthings.list_bears()
      |> Enum.filter(fn(bear) -> Bear.is_grizzly(bear) end)
      |> Enum.sort(fn(b1, b2) -> Bear.order_asc_by_name(b1, b2) end)
      |> Enum.map(fn(bear) -> bear_item(bear) end)
      |> Enum.join

    %{ conv | status: 200, resp_body: "<ul>#{items}</ul>" }
  end

  def show(conv, %{"id" => id}) do
    bear = Wildthings.get_bear(id)

    %{ conv | status: 200, resp_body: "<h1>Bear #{bear.id}: #{bear.name}</h1>" }
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{ conv | status: 201, resp_body: "Create a #{type} bear named #{name}!" }
  end

end
