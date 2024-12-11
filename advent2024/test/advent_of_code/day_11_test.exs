defmodule AdventOfCode.Day11Test do
  use ExUnit.Case

  import AdventOfCode.Day11

  @input "125 17"

  test "part1_sample" do
    result = part1("125 17", 6)
    assert result == 22
  end

  test "part1" do
    result = part1(@input)

    assert result == 55312
  end

  test "part2" do
    result = part2(@input)

    assert result
  end
end
