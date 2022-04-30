defmodule OKTest do
  use ExUnit.Case
  doctest OK

  # ch12 ControlFlow-1
  test "returns the data if result is ok" do
    assert OK.ok!({:ok, "test"}) == "test"
  end

  test "raises an error if result is not ok" do
    assert_raise(RuntimeError, fn -> OK.ok!({:error, "test"}) end)
  end
end
