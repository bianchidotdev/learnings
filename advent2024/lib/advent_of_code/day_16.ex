defmodule AdventOfCode.Day16.Maze do
  defstruct self: nil, direction: :east, end: nil, walls: []
end

defmodule AdventOfCode.Day16 do
  alias AdventOfCode.Day16.Maze

  def part1(input) do
    maze = parse_maze(input)

    traverse(maze)
    |> List.flatten()
    |> Enum.filter(fn {_, _, [last_pos | _]} -> last_pos == maze.end end)
    |> Enum.map(fn {_, actions, _} -> calculate_path_score(actions) end)
    |> Enum.min()
  end

  def part2(_args) do
  end

  defp calculate_path_score(actions) do
    Enum.map(actions, fn
      {:turn, _dir} -> 1001
      {:straight, _dir} -> 1
    end)
    |> Enum.sum()
  end

  defp traverse(maze) do
    traverse(maze, [], [])
  end

  defp traverse(%Maze{self: self, end: end_pos} = maze, actions, path) when self == end_pos,
    do: {maze, actions, path}

  # TODO: convert to not store all paths and instead just the minimum cost to get to a given point
  defp traverse(maze, actions, path) do
    possible_moves(maze)
    |> Enum.reject(fn {_action, new_pos} -> Enum.member?(path, new_pos) end)
    |> Enum.map(fn {action, new_pos} ->
      {_face, direction} = action

      new_path = [new_pos | path]
      new_actions = [action | actions]

      maze
      |> Map.put(:direction, direction)
      |> Map.put(:self, new_pos)
      |> traverse(new_actions, new_path)
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
