defmodule WebSpirit.PledgeController do
  def index(conv) do
    # Gets the recent pledges from the cache
    pledges = WebSpirit.PledgeServer.recent_pledges()

    %{ conv | status: 200, resp_body: (inspect pledges) }
  end

  def create(conv, %{"name" => name, "amount" => amount}) do
    # Sends the pledge to the external service and caches it
    WebSpirit.PledgeServer.create_pledge(name, String.to_integer(amount))

    %{ conv | status: 201, resp_body: "#{name} pledged #{amount}!" }
  end
end
