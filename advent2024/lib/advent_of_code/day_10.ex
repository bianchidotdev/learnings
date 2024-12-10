defmodule AdventOfCode.Day10 do
  def part1(input) do
    parsed = parse_input(input)
    trailheads = Map.get(parsed, 0, [])

    trailheads
    |> Enum.map(fn {row_index, column_index} ->
      follow_path({0, {row_index, column_index}}, parsed, [])
    end)
    |> Enum.map(fn list -> list |> List.flatten() |> Enum.uniq() |> Enum.count() end)
    |> Enum.sum()
  end

  def part2(input) do
    parsed = parse_input(input)
    trailheads = Map.get(parsed, 0, [])

    trailheads
    |> Enum.map(fn {row_index, column_index} ->
      follow_path({0, {row_index, column_index}}, parsed, [])
    end)
    |> Enum.map(fn list -> list |> List.flatten() |> Enum.count() end)
    |> Enum.sum()
  end

  defp follow_path({height, pos}, _parsed, acc) when height == 9 do
    [pos | acc]
  end

  defp follow_path({height, {row_index, column_index}}, parsed, acc) do
    paths =
      [
        {row_index + 1, column_index},
        {row_index - 1, column_index},
        {row_index, column_index + 1},
        {row_index, column_index - 1}
      ]

    paths
    |> Enum.filter(fn next_pos -> Map.get(parsed, height + 1, []) |> Enum.member?(next_pos) end)
    |> Enum.map(fn next_pos -> follow_path({height + 1, next_pos}, parsed, acc) end)
  end

  defp parse_input(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    # converts grid into map of {value => [{row_index, column_index}, ...]}
    for {row, row_index} <- Enum.with_index(grid),
        {column, column_index} <- Enum.with_index(row) do
      {String.to_integer(column), {row_index, column_index}}
    end
    |> Enum.reduce(%{}, fn {value, {row_index, column_index}}, acc ->
      Map.update(acc, value, [{row_index, column_index}], fn
        nil ->
          [{row_index, column_index}]

        existing ->
          [{row_index, column_index} | existing]
      end)
    end)
  end
end
