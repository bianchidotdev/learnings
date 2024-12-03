defmodule AdventOfCode.Day02 do
  def part1(input) do
    parse_input(input)
    |> Enum.filter(&safe?/1)
    |> Enum.count()
    # |> Enum.map(&diffs/1)
    # |> Enum.filter(&diffs_safe?/1)
    # |> Enum.count()
  end

  def part2(input) do
    safe_rows = parse_input(input)
    |> Enum.filter(&safe?/1)

    safe_with_tolerance = parse_input(input)
    |> Enum.reject(&safe?/1)
    |> Enum.filter(&(any_safe?/1))

    Enum.count(safe_rows) + Enum.count(safe_with_tolerance)
  end

  defp any_safe?(row) do
    0..length(row)
    |>Enum.map(fn i -> List.delete_at(row, i) end)
    |> Enum.any?(&safe?/1)
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(fn row -> Enum.map(row, &String.to_integer/1) end)
  end

  defp safe?([first | [second | _]] = row) do
    if first > second do
      safe?(row, :decreasing)
    else
      safe?(row, :increasing)
    end
  end

  defp safe?([first | [second | rest]], :increasing) do
    diff = abs(first - second)
    if first < second && diff >= 1 && diff <= 3 do
      safe?([second | rest], :increasing)
      else
        false
    end
  end

  defp safe?([first | [second | rest]], :decreasing) do
    diff = abs(first - second)
    if first > second && diff >= 1 && diff <= 3 do
        safe?([second | rest], :decreasing)
      else
        false
    end
  end

  defp safe?(_, _), do: true

  # defp diffs(levels) do
  #   diffs(levels, [])
  # end

  # defp diffs([first | [second | rest]], acc) do
  #   diffs([second | rest], [second - first | acc])
  # end

  # defp diffs(_, acc) do
  #   Enum.reverse(acc)
  # end

  # defp diffs_safe?([head | _] = diffs) when head > 0 do
  #   diffs
  #   |> Enum.all?(fn diff -> diff > 0 && diff >= 1 && diff <= 3 end)
  # end

  # defp diffs_safe?([head | _] = diffs) when head < 0 do
  #   diffs
  #   |> Enum.all?(fn diff -> diff < 0 && diff <= -1 && diff >= -3 end)
  # end

  # defp diffs_safe?(_), do: false
end
