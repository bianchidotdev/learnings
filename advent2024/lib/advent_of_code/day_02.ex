defmodule AdventOfCode.Day02 do
  def part1(input) do
    parse_input(input)
    |> Enum.map(&diffs/1)
    |> Enum.filter(&diffs_safe?/1)
    |> Enum.count()
  end

  def part2(input) do
    parsed = parse_input(input)
    # partition parsed into safe and unsafe by diffs_safe?
    {safe, unsafe} =
      parsed
      |> Enum.partition(fn row -> diffs_safe?(diffs(row)) end)

    safe_with_dampener = unsafe
    |> Enum.filter(&any_safe?/1)

    Enum.count(safe) + Enum.count(safe_with_dampener)
  end

  defp any_safe?(row) do
    0..length(row)
    |> Enum.map(fn i -> List.delete_at(row, i) end)
    |> Enum.map(&diffs/1)
    |> Enum.any?(&diffs_safe?/1)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  defp diffs(levels) do
    diffs(levels, [])
  end

  defp diffs([first | [second | rest]], acc) do
    diffs([second | rest], [second - first | acc])
  end

  defp diffs(_, acc) do
    Enum.reverse(acc)
  end

  defp diffs_safe?([head | _] = diffs) when head > 0 do
    diffs
    |> Enum.all?(fn diff -> diff >= 1 && diff <= 3 end)
  end

  defp diffs_safe?([head | _] = diffs) when head < 0 do
    diffs
    |> Enum.all?(fn diff -> diff <= -1 && diff >= -3 end)
  end

  defp diffs_safe?(_), do: false
end
