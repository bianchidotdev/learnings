defmodule AdventOfCode.Day15 do
  def part1(input) do
    {grid, steps} = parse_input(input)
    final_grid = step(grid, steps)

    calculate_gps_coordinates(final_grid)
    |> Enum.sum()
  end

  def part2(_args) do
  end

  defp calculate_gps_coordinates(grid) do
    grid[:box]
    |> Enum.map(fn {x, y} -> x + y * 100 end)
  end

  defp step(grid, []), do: grid

  defp step(grid, [step | rest]) do
    new_grid = apply_step(grid, step)
    step(new_grid, rest)
  end

  defp apply_step(grid, step) do
    [robot] = grid[:robot]

    dir =
      case step do
        "<" -> {-1, 0}
        ">" -> {1, 0}
        "^" -> {0, -1}
        "v" -> {0, 1}
      end

    apply_step(grid, robot, dir)
  end

  defp apply_step(grid, robot, step) do
    changes = move(grid, robot, step, [])

    changes
    |> Enum.reduce(grid, fn {type, old_pos, new_pos}, acc ->
      Map.update(acc, type, [new_pos], fn list ->
        new_list = List.delete(list, old_pos)
        [new_pos | new_list]
      end)
    end)
  end

  defp move(grid, {x, y} = pos, {dx, dy} = step, changes) do
    current = identify_position(pos, grid)
    new_pos = {x + dx, y + dy}

    case identify_position(new_pos, grid) do
      :empty ->
        [{current, pos, new_pos} | changes]

      :box ->
        move(grid, new_pos, step, [{current, pos, new_pos} | changes])

      :wall ->
        []
    end
  end

  defp identify_position(position, grid) do
    cond do
      Enum.member?(grid[:box], position) -> :box
      Enum.member?(grid[:wall], position) -> :wall
      Enum.member?(grid[:robot], position) -> :robot
      true -> :empty
    end
  end

  defp parse_input(input) do
    [grid_input, steps_input] =
      input
      |> String.split("\n\n", trim: true)

    grid =
      grid_input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    by_value =
      for {row, row_index} <- Enum.with_index(grid) do
        for {value, col_index} <- Enum.with_index(row) do
          {value, {col_index, row_index}}
        end
      end
      |> List.flatten()
      |> Enum.reduce(%{}, fn {value, {col_index, row_index}}, acc ->
        value_key =
          case value do
            "#" -> :wall
            "O" -> :box
            "@" -> :robot
            "." -> :empty
          end

        Map.update(acc, value_key, [{col_index, row_index}], fn
          existing ->
            [{col_index, row_index} | existing]
        end)
      end)

    steps =
      steps_input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> List.flatten()

    {by_value, steps}
  end
end
