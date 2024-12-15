defmodule AdventOfCode.Day14.Robot do
  defstruct(position: {0, 0}, velocity: {0, 0})
end

defmodule AdventOfCode.Day14 do
  alias AdventOfCode.Day14.Robot

  def part1(input, grid \\ {11, 7}) do
    seconds = 100

    parse_input(input)
    |> Enum.map(&calc_position(&1, seconds, grid))
    |> split_into_quadrants(grid)
    |> Enum.map(fn {_quadrant, positions} -> Enum.count(positions) end)
    |> Enum.reduce(1, fn num, acc -> num * acc end)
  end

  def part2(input) do
    parse_input(input)
    |> find_tree({101, 103})
  end

  def find_tree(robots, grid) do
    Enum.find(1..10000, fn seconds ->
      positions = Enum.map(robots, &calc_position(&1, seconds, grid))

      Enum.reduce(positions, %{}, fn position, acc ->
        Map.update(acc, position, 1, fn count -> count + 1 end)
      end)
      |> print_grid(grid, seconds)

      # Process.sleep(200)
    end)
  end

  defp print_grid(positions, {grid_x, grid_y}, seconds) do
    string =
      Enum.reduce(0..(grid_y - 1), "", fn y, string ->
        new_string =
          Enum.reduce(0..(grid_x - 1), string, fn x, inner_string ->
            if(Map.has_key?(positions, {x, y})) do
              inner_string <> "x"
            else
              inner_string <> " "
            end
          end)

        new_string <> "\n"
      end)

    if Regex.match?(~r/x{20,}/, string) do
      IO.puts("----- #{seconds} -----")
      IO.puts(string)
      true
    else
      false
    end
  end

  # def is_tree?(positions, _) do
  #   columns =
  #     Enum.reduce(positions, %{}, fn {x, _}, columns ->
  #       Map.update(columns, x, 1, fn count -> count + 1 end)
  #     end)

  #   {middle_index, middle_count} =
  #     Enum.max_by(columns, fn {_index, count} -> count end)

  #   if middle_count > 20 do
  #     dbg({middle_index, middle_count})
  #   end

  #   res =
  #     Enum.all?(1..2, fn index ->
  #       lower = Map.get(columns, middle_index - index, 0)
  #       higher = Map.get(columns, middle_index + index, 0)

  #       # && lower == higher do
  #       if middle_count > 20 && lower > 15 && higher > 15 do
  #         true
  #       else
  #         false
  #       end
  #     end)

  #   # if !!res do
  #   #   IO.puts("Found tree at #{}")
  #   # end

  #   !!res
  # end

  def calc_position(robot, seconds, {grid_x, grid_y}) do
    %{position: {x, y}, velocity: {vx, vy}} = robot
    new_x = Integer.mod(x + vx * seconds, grid_x)
    new_y = Integer.mod(y + vy * seconds, grid_y)
    {new_x, new_y}
  end

  def split_into_quadrants(positions, {grid_x, grid_y}) do
    Enum.reduce(positions, %{}, fn {x, y}, quads ->
      x_mid = div(grid_x, 2)
      y_mid = div(grid_y, 2)

      cond do
        x in 0..(x_mid - 1) && y in 0..(y_mid - 1) ->
          Map.update(quads, :topleft, [{x, y}], fn list -> [{x, y} | list] end)

        x in (x_mid + 1)..grid_x && y in 0..(y_mid - 1) ->
          Map.update(quads, :topright, [{x, y}], fn list -> [{x, y} | list] end)

        x in 0..(x_mid - 1) && y in (y_mid + 1)..grid_y ->
          Map.update(quads, :bottomleft, [{x, y}], fn list -> [{x, y} | list] end)

        x in (x_mid + 1)..grid_x && y in (y_mid + 1)..grid_y ->
          Map.update(quads, :bottomright, [{x, y}], fn list -> [{x, y} | list] end)

        true ->
          quads
      end
    end)
  end

  def parse_input(input) do
    robot_strings =
      input
      |> String.split("\n", trim: true)

    extract_regex = ~r/p=(?<pos_x>-?\d+),(?<pos_y>-?\d+) v=(?<vel_x>-?\d+),(?<vel_y>-?\d+)/

    Enum.map(robot_strings, fn string ->
      captures = Regex.named_captures(extract_regex, string)

      %Robot{
        position: {String.to_integer(captures["pos_x"]), String.to_integer(captures["pos_y"])},
        velocity: {String.to_integer(captures["vel_x"]), String.to_integer(captures["vel_y"])}
      }
    end)
  end
end
