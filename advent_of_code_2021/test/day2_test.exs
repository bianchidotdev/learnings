defmodule AdventOfCode2021Test.Day2 do
  use ExUnit.Case
  doctest AdventOfCode2021.Day2

  test "calculates final position and returns product of coordinate" do
    assert AdventOfCode2021.Day2.ex1() == 2_322_630
  end

  test "calculates final position and returns product of coordinate with aim" do
    assert AdventOfCode2021.Day2.ex2() == 2_105_273_490
  end
end
