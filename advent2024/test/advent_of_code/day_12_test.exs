defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12

  @input """
  RRRRIICCFF
  RRRRIICCCF
  VVRRRCCFFF
  VVRCCCJFFF
  VVVVCJJCFE
  VVIVCCJJEE
  VVIIICJJEE
  MIIIIIJJEE
  MIIISIJEEE
  MMMISSJEEE
  """

  @tag :skip
  test "part1-short" do
    assert part1("""
           AAAA
           BBCD
           BBCC
           EEEC
           """) == 140
  end

  @tag :skip
  test "part1-encompass" do
    assert part1("""
           OOOOO
           OXOXO
           OOOOO
           OXOXO
           OOOOO
           """) == 772
  end

  @tag :skip
  test "part1" do
    result = part1(@input)

    assert result == 1930
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
