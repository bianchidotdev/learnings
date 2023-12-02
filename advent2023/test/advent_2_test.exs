defmodule Advent2Test do
  use ExUnit.Case
  doctest Advent2

  setup do
    input = ResourceHelper.get_resource("advent_2.txt")
    {:ok, input: input}
  end

  test "solves the problem", ctx do
    assert Advent2.solve(ctx.input) == 2476
  end

  test "solves the second part", ctx do
    assert Advent2.solve(ctx.input, :part2) == 54911
  end
end
