defmodule WebSpirit.PledgeServer do
  def create_pledge(name, amount) do
    {:ok, id} = send_pledge_to_service(name, amount)

    # Cache the pledge:
    [ {"pepe", 10} ]
  end

  def recent_pledges do
    # Returns the most recent pledges (cache):
    [ {"pepe", 10} ]
  end

  def send_pledge_to_service(_name, _amount) do
    # Code goes here to send pledge to external service
    {:ok, "pledge-#{:rand.uniform(1000)}"}
  end
end
