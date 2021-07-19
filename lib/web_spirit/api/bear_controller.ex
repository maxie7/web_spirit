defmodule WebSpirit.Api.BearController do
  def index(conv) do
    json =
      WebSpirit.Wildthings.list_bears()
      |> Poison.encode!

    %{ conv | status: 200, resp_content_type: "application/json", resp_body: json }
  end
end
