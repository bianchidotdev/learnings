defmodule Advent3Test do
  use ExUnit.Case
  doctest Advent3

  setup do
    input = ResourceHelper.get_resource("advent_3.txt")
    {:ok, input: input}
  end

  test "solves the problem", ctx do
    assert Advent3.solve(ctx.input) == 532331
  end

  # test "solves the second part", ctx do
  #   assert Advent3.solve(ctx.input, :part2) == 54911
  # end
end
