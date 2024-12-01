defmodule AdventOfCode2021Test.Day3 do
  use ExUnit.Case
  doctest AdventOfCode2021.Day3

  test "calculates final position and returns product of coordinate" do
    assert AdventOfCode2021.Day3.ex1() == 3_148_794
  end

  test "calculates final position and returns product of coordinate with aim" do
    assert AdventOfCode2021.Day3.ex2() == 2_795_310
  end
end
