defmodule WebSpirit.SpiritController do

  alias WebSpirit.Wildthings

  def index(conv) do
    bears = Wildthings.list_bears()

    # TODO: Transform bears to an html list

    %{ conv | status: 200, resp_body: "<ul><li>Name</li></ul>" }
  end

  def show(conv, %{"id" => id}) do
    %{ conv | status: 200, resp_body: "Bear #{id}" }
  end

  def create(conv, %{"name" => name, "type" => type} = params) do
    %{ conv | status: 201, resp_body: "Create a #{type} bear named #{name}!" }
  end

end
