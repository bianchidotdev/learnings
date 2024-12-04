defmodule AdventOfCode.Day03 do
  def part1(input) do
    parsed = parse(input)

    Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)/, parsed)
    |> Enum.map(fn [match] -> calc_mul(match) end)
    |> Enum.sum()
  end

  def part2(input) do
    parsed = parse(input)

    [first | dont_parts] = String.split(parsed, "don't()")
    do_parts = dont_parts
    |> Enum.map(fn part -> String.split(part, "do()", parts: 2) end)
    |> Enum.map(&Enum.at(&1, 1))
    |> Enum.filter(&(&1))

    [first | do_parts]
    |> Enum.flat_map(fn part -> Regex.scan(~r/mul\(\d{1,3},\d{1,3}\)/, part) end)
    |> Enum.map(fn [match] -> calc_mul(match) end)
    |> Enum.sum()
  end

  defp parse(input) do
    input
    |> String.trim()
  end

  defp calc_mul(match) do
    captures = Regex.named_captures(~r/mul\((?<a>\d{1,3}),(?<b>\d{1,3})\)/, match)
    String.to_integer(captures["a"]) * String.to_integer(captures["b"])
  end
end
