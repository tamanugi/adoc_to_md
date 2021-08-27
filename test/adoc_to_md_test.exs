defmodule AdocToMdTest do
  use ExUnit.Case
  doctest AdocToMd

  test "greets the world" do
    assert AdocToMd.hello() == :world
  end
end
