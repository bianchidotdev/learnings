require Logger

defmodule AdventOfCode.Day04 do
  def part1(input) do
    parse_input(input)
    |> get_positions()
    |> find_patterns()
    |> Enum.filter(& &1)
    |> Enum.count()
  end

  def part2(_args) do
  end

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
  end

  defp get_positions(rows) do
    ["X", "M", "A", "S"]
    |> Enum.reduce(%{}, fn letter, map ->
      Map.put(map, letter, find_positions(rows, letter))
    end)
  end

  defp find_positions(rows, letter) do
    Enum.with_index(rows)
    |> Enum.flat_map(fn {row, row_index} ->
      matches = Regex.scan(~r/#{letter}/, row, return: :index)
      Enum.map(matches, fn [{column_index, _}] -> {row_index, column_index} end)
    end)
    |> Enum.reduce(%{}, &Map.put(&2, &1, true))
  end

  defp find_patterns(positions) do
    positions["X"]
    |> Enum.flat_map(fn {{row, column}, _} ->
      for x_op <- [:-, :=, :+],
          y_op <- [:-, :=, :+],
          x_op != := or y_op != := do
        check_positions(positions, row, column, x_op, y_op)
      end
    end)
  end

  defp check_positions(positions, row, column, x_op, y_op) do
    weights = %{"M" => 1, "A" => 2, "S" => 3}

    match =
      Enum.all?(["M", "A", "S"], fn letter ->
        Map.has_key?(
          positions[letter],
          {get_position(row, x_op, weights[letter]), get_position(column, y_op, weights[letter])}
        )
      end)

    # if match do
    # Logger.info("Match: #{row}, #{column}, #{x_op}, #{y_op}: #{match}")
    # end

    match
  end

  defp get_position(val, :-, weight), do: val - weight
  defp get_position(val, :=, _), do: val
  defp get_position(val, :+, weight), do: val + weight
end
