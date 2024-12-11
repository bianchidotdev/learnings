defmodule AdventOfCode.Day11 do
  def part1(input, blinks \\ 25) do
    parsed = parse_input(input)

    parsed
    |> blink(blinks)
    |> Enum.count()
  end

  def part2(input) do
    part1(input, 75)
  end

  defp blink(stones, 0), do: stones

  defp blink(stones, blinks) do
    stones
    |> Enum.reduce([], fn stone, acc ->
      stone_string = Integer.to_string(stone)

      cond do
        stone == 0 ->
          [1 | acc]

        Integer.mod(String.length(stone_string), 2) == 0 ->
          {a, b} = String.split_at(stone_string, String.length(stone_string) |> div(2))
          [String.to_integer(a), String.to_integer(b) | acc]

        true ->
          [stone * 2024 | acc]
      end
    end)
    |> blink(blinks - 1)
  end

  defp parse_input(input) do
    input
    |> String.split(~r/\s/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
