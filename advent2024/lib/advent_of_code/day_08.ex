defmodule AdventOfCode.Day08 do
  def part1(input) do
    {antennas, grid_size} = parse_input(input)

    antennas
    |> Enum.map(fn {_char, positions} ->
      calculate_antinodes(positions, grid_size, false)
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.count()
  end

  def part2(input) do
    {antennas, grid_size} = parse_input(input)

    antennas
    |> Enum.map(fn {_char, positions} ->
      calculate_antinodes(positions, grid_size, true)
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.sort()
    |> Enum.count()
  end

  defp calculate_antinodes(positions, grid_size, harmonic) do
    calculate_antinodes(positions, grid_size, harmonic, [])
  end

  defp calculate_antinodes([_just_one], _, _harmonic, acc), do: acc

  defp calculate_antinodes([first, second | rest], grid_size, harmonic, acc) do
    acc = [antinodes(first, second, grid_size, harmonic) | acc]

    calculate_antinodes([first | rest], grid_size, harmonic, acc) ++
      calculate_antinodes([second | rest], grid_size, harmonic, acc)
  end

  defp antinodes({x1, y1}, {x2, y2}, grid_size, false) do
    [
      {x1 - x2 + x1, y1 - y2 + y1},
      {x2 - x1 + x2, y2 - y1 + y2}
    ]
    |> Enum.filter(&in_bounds?(&1, grid_size))
  end

  defp antinodes({x1, y1} = a, {x2, y2} = b, grid_size, true) do
    delta_x = x1 - x2
    delta_y = y1 - y2

    harmonic_antinodes(a, {delta_x, delta_y}, grid_size, [a]) ++
      harmonic_antinodes(b, {-delta_x, -delta_y}, grid_size, [b])
  end

  defp harmonic_antinodes({x, y}, {delta_x, delta_y} = delta, grid_size, acc) do
    prospective_point = {x + delta_x, y + delta_y}

    if in_bounds?(prospective_point, grid_size) do
      [prospective_point | harmonic_antinodes(prospective_point, delta, grid_size, acc)]
    else
      acc
    end
  end

  defp in_bounds?({x, y}, {width, height}), do: x >= 0 and y >= 0 and x < width and y < height

  defp parse_input(input) do
    lines =
      input
      |> String.split("\n", trim: true)

    map =
      lines
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {line, line_index}, acc ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, index}, acc ->
          {_, acc} =
            case char do
              "." ->
                {acc, acc}

              char ->
                Map.get_and_update(acc, char, fn
                  nil -> {nil, [{index, line_index}]}
                  array -> {array, [{index, line_index} | array]}
                end)
            end

          acc
        end)
      end)

    {map, {String.length(Enum.at(lines, 0)), Enum.count(lines)}}
  end
end
