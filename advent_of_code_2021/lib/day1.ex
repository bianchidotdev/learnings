defmodule AdventOfCode2021.Day1 do
  alias AdventOfCode2021.InputHandler, as: InputHandler

  def input do
    InputHandler.input(1) |>
      Enum.map(&String.to_integer/1)
  end

  def ex1 do
    input() |>
      compare(0)
  end

  def ex2 do
    input() |>
      sliding_compare(0)
  end

  def compare(list, acc) when length(list) < 2 do
    acc
  end
  def compare([first | [second | rest]], acc) when first < second do
    compare([second | rest], acc + 1)
  end

  def compare([_ | rest], acc) do
    compare(rest, acc)
  end

  def sliding_compare(list, acc) when length(list) < 4 do
    acc
  end

  def sliding_compare([first | [second | [third | [fourth | rest]]]], acc) do
    if first + second + third < second + third + fourth do
      sliding_compare([second | [third | [fourth | rest]]], acc + 1)
    else
      sliding_compare([second | [third | [fourth | rest]]], acc)
    end
  end
end
