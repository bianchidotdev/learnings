defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09

  @input """
  2333133121414131402
  """

  test "part1" do
    result = part1(@input)

    assert result == 1928
  end

  test "part2" do
    result = part2(@input)

    assert result == 2858
  end
end
