defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  @input """
  Register A: 729
  Register B: 0
  Register C: 0

  Program: 0,1,5,4,3,0
  """

  test "part1" do
    result = part1(@input)

    assert(result == "4,6,3,5,6,3,5,2,1,0")
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
