defmodule IceTest do
  use ExUnit.Case
  doctest Ice

  test "greets the world" do
    assert Ice.hello() == :world
  end
end
