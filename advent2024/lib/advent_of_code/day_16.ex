defmodule AdventOfCode.Day16.Maze do
  defstruct self: nil, direction: :east, end: nil, walls: []
end

defmodule AdventOfCode.Day16 do
  alias AdventOfCode.Day16.Maze

  def part1(input) do
    maze = parse_maze(input)

    traverse(maze)
    |> Map.get(maze.end)
  end

  def part2(_args) do
  end

  defp traverse(maze) do
    traverse(maze, %{maze.self => 0})
  end

  defp traverse(maze, path) when maze.self == maze.end do
    path
  end

  # TODO: convert to not store all paths and instead just the minimum cost to get to a given point
  defp traverse(maze, path) do
    moves = possible_moves(maze)

    Enum.reduce(moves, path, fn {{turn, direction}, new_pos}, path ->
      previous_step_cost = Map.get(path, maze.self, 0)

      new_cost =
        case turn do
          :turn -> previous_step_cost + 1001
          :straight -> previous_step_cost + 1
        end

      existing_cost = Map.get(path, new_pos)

      if new_cost < existing_cost do
        new_path =
          Map.update(path, new_pos, new_cost, fn
            old_cost -> min(old_cost, new_cost)
          end)

        maze
        |> Map.put(:direction, direction)
        |> Map.put(:self, new_pos)
        |> traverse(new_path)
      else
        path
      end
    end)
  end

  defp possible_moves(maze) do
    {x, y} = maze.self

    directions = %{
      north: [{:straight, :north}, {:turn, :west}, {:turn, :east}],
      east: [{:straight, :east}, {:turn, :north}, {:turn, :south}],
      south: [{:straight, :south}, {:turn, :west}, {:turn, :east}],
      west: [{:straight, :west}, {:turn, :north}, {:turn, :south}]
    }

    deltas = %{
      north: {0, -1},
      east: {1, 0},
      south: {0, 1},
      west: {-1, 0}
    }

    directions
    |> Map.get(maze.direction)
    |> Enum.map(fn {_face, direction} = action ->
      {dx, dy} = deltas[direction]
      {action, {x + dx, y + dy}}
    end)
    |> Enum.reject(fn {_, {x, y}} ->
      {x, y} in maze.walls
    end)
  end

  defp parse_maze(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
        |> Enum.map(fn char ->
          case char do
            "." -> :empty
            "#" -> :wall
            "S" -> :self
            "E" -> :end
          end
        end)
      end)

    grid
    |> Enum.with_index()
    |> Enum.reduce(%Maze{}, fn {row, row_index}, maze ->
      row
      |> Enum.with_index()
      |> Enum.reduce(maze, fn {value, col_index}, maze ->
        case value do
          :wall ->
            Map.update(maze, :walls, [{col_index, row_index}], fn walls ->
              [{col_index, row_index} | walls]
            end)

          :self ->
            Map.update(maze, :self, {col_index, row_index}, fn _self ->
              {col_index, row_index}
            end)

          :end ->
            Map.update(maze, :end, {col_index, row_index}, fn _end ->
              {col_index, row_index}
            end)

          _ ->
            maze
        end
      end)
    end)
  end
end
