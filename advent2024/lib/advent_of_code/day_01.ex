defmodule AdventOfCode.Day01 do
  def part1(input) do
    [list1, list2] = trim_transpose_and_sort(input)

    Enum.zip(list1, list2)
    |> Enum.map(fn {a, b} -> abs(a - b) end)
    |> Enum.sum()
  end

  def part2(input) do
    [list1, list2] = trim_transpose_and_sort(input)

    frequencies = Enum.frequencies(list2)

    Enum.map(list1, &multiply_by_occurrences(&1, frequencies))
    |> Enum.sum()
  end

  defp trim_transpose_and_sort(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn row ->
      [first, second] = String.split(row, ~r{\s+})
      [String.to_integer(first), String.to_integer(second)]
    end)
    |> List.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.sort/1)
  end

  defp multiply_by_occurrences(value, frequencies) do
    case frequencies[value] do
      nil -> 0
      n -> n * value
    end
  end
end
