defmodule Grid do
  defstruct grid: [], guard: nil, obstacles: [], width: 0, height: 0
end

defmodule AdventOfCode.Day06 do
  @next_direction %{
    up: :right,
    right: :down,
    down: :left,
    left: :up
  }

  def part1(input) do
    parse_input(input)
    |> calculate_path()
    |> Enum.map(fn {{position, _}, _} -> position end)
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2(input) do
    grid = parse_input(input)
    {guard_pos, _} = grid.guard

    processes =
      for x <- 0..(grid.width - 1),
          y <- 0..(grid.height - 1),
          !Enum.member?(grid.obstacles, {x, y}) and guard_pos != {x, y} do
        obstacles = [{x, y} | grid.obstacles]
        Task.async(fn -> calculate_path(%{grid | obstacles: obstacles}) end)
      end

    results = Enum.map(processes, &Task.await/1)

    results |> Enum.filter(&(&1 == false)) |> Enum.count()
  end

  defp calculate_path(grid) do
    calculate_path(grid, %{})
  end

  defp calculate_path(%Grid{} = grid, path) do
    path = Map.put(path, grid.guard, true)
    {{next_x, next_y}, _} = next_guard = calculate_next_guard_position(grid)

    cond do
      Map.has_key?(path, next_guard) ->
        false

      next_x < 0 or next_x >= grid.width or next_y < 0 or next_y >= grid.height ->
        path

      true ->
        grid = %{grid | guard: next_guard}
        calculate_path(grid, path)
    end
  end

  defp calculate_next_guard_position(grid) do
    {{guard_x, guard_y}, direction} = grid.guard

    {{next_x, next_y}, _} =
      next_guard =
      case direction do
        :up -> {{guard_x, guard_y - 1}, :up}
        :right -> {{guard_x + 1, guard_y}, :right}
        :down -> {{guard_x, guard_y + 1}, :down}
        :left -> {{guard_x - 1, guard_y}, :left}
      end

    if Enum.member?(grid.obstacles, {next_x, next_y}) do
      grid = %{grid | guard: {{guard_x, guard_y}, @next_direction[direction]}}
      calculate_next_guard_position(grid)
    else
      next_guard
    end
  end

  defp parse_input(input) do
    parsed =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    grid = %Grid{grid: parsed, width: Enum.count(parsed), height: Enum.count(Enum.at(parsed, 0))}

    parsed
    |> Enum.with_index()
    |> Enum.reduce(grid, fn {line, line_index}, acc ->
      obstacles =
        line
        |> Enum.with_index()
        |> Enum.reduce(acc.obstacles, fn {char, index}, acc ->
          case char do
            "#" -> [{index, line_index} | acc]
            _ -> acc
          end
        end)

      guard =
        case find_guard(line) do
          {index, direction} -> {{index, line_index}, direction}
          nil -> acc.guard
        end

      %{acc | guard: guard, obstacles: obstacles}
    end)
  end

  defp find_guard(line) do
    line
    |> Enum.with_index()
    |> Enum.reduce(nil, fn
      {"^", index}, _ -> {index, :up}
      {">", index}, _ -> {index, :right}
      {"v", index}, _ -> {index, :down}
      {"<", index}, _ -> {index, :left}
      _, acc -> acc
    end)
  end
end
