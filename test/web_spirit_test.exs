defmodule WebSpiritTest do
  use ExUnit.Case
  doctest WebSpirit

  test "greets the world" do
    assert WebSpirit.hello() == :world
  end
end
