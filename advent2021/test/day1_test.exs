defmodule AdventOfCode2021Test.Day1 do
  use ExUnit.Case
  doctest AdventOfCode2021.Day1

  test "calculates increasing depth" do
    assert AdventOfCode2021.Day1.ex1() == 1557
  end

  test "calculates increasing depth on a sliding window" do
    assert AdventOfCode2021.Day1.ex2() == 1608
  end
end
