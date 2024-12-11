defmodule AdventOfCode.Day11 do
  def part1(input, blinks \\ 25) do
    # {:ok, cache} = GenServer.start_link(AdventOfCode.Day11.Cache, [])
    parsed = parse_input(input)

    parsed
    |> Enum.reduce(%{}, fn stone, acc -> Map.update(acc, stone, 1, &(&1 + 1)) end)
    |> blink(blinks)
    |> Enum.map(fn {_k, v} -> v end)
    |> Enum.sum()
  end

  def part2(input) do
    part1(input, 75)
  end

  defp blink(stones, 0), do: stones

  defp blink(stones, blinks) do
    new_stones =
      stones
      |> Enum.reduce(%{}, fn {stone, count}, acc ->
        case calc_new_stones(stone) do
          {a, b} ->
            acc = Map.update(acc, a, count, &(&1 + count))
            Map.update(acc, b, count, &(&1 + count))

          new_stone ->
            Map.update(acc, new_stone, count, &(&1 + count))
        end
      end)

    blink(new_stones, blinks - 1)
  end

  defp calc_new_stones(stone) do
    stone_string = Integer.to_string(stone)

    cond do
      stone == 0 ->
        1

      Integer.mod(String.length(stone_string), 2) == 0 ->
        {a, b} = String.split_at(stone_string, String.length(stone_string) |> div(2))
        {String.to_integer(a), String.to_integer(b)}

      true ->
        stone * 2024
    end
  end

  defp parse_input(input) do
    input
    |> String.split(~r/\s/, trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
