defmodule Advent1Test do
  use ExUnit.Case
  doctest Advent1

  setup do
    input = ResourceHelper.get_resource("advent_1.txt")
    {:ok, input: input}
  end

  test "calculates the sample" do
    input = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

    assert Advent1.solve(input) == 142
  end

  test "solves the problem", ctx do
    assert Advent1.solve(ctx.input) == 53868
  end
end
