defmodule AdventOfCode.Day12 do
  def part1(input) do
    {_grid, plot_types} = parse_input(input)

    # {area, perimeter} =
    plot_types
    |> calc_regions()

    # |> Enum.map(fn positions ->
    #   positions_with_boundaries =
    #     positions
    #     |> Enum.map(fn pos ->
    #       num_neighbors =
    #         positions
    #         |> Enum.filter(&is_neighbor?(&1, pos))
    #         |> Enum.count()

    #       {pos, 4 - num_neighbors}
    #     end)

    #   Enum.reduce(positions_with_boundaries, {0, 0}, fn {_, boundary}, {area, perimeter} ->
    #     {area + 1, perimeter + boundary}
    #   end)
    # end)

    # |> Enum.map(fn {area, perimeter} -> area * perimeter end)
    # |> Enum.sum()

    # |> Enum.reduce({0, 0}, fn {size, boundary_count}, {area, perimeter} ->
    #   {area + size, perimeter + boundary_count}
    # end)

    # area * perimeter
  end

  def part2(_args) do
  end

  defp calc_regions(plot_types) do
    plot_types
    |> Enum.reduce(%{}, fn {value, positions}, acc ->
      region_prospects = group_neighbors(positions, [])
      regions = group_regions(region_prospects)
      Map.put(acc, value, regions)
    end)
  end

  defp group_neighbors([a | rest], acc) do
    region =
      rest
      |> Enum.reduce([a], fn pos, region ->
        is_in_region = Enum.any?(region, &is_neighbor?(&1, pos))

        case is_in_region do
          true -> [pos | region]
          false -> region
        end
      end)

    not_in_region = Enum.reject(rest, &Enum.member?(region, &1))

    group_neighbors(not_in_region, [region | acc])
  end

  defp group_neighbors(_, acc), do: acc

  defp group_regions([a | rest]) do
    a
    |> Enum.find(fn pos ->
      Enum.any?(rest, fn pos_b -> is_neighbor?(pos, pos_b) end)
    end)
  end

  defp is_neighbor?({x, y}, prospect) do
    [
      {x - 1, y},
      {x + 1, y},
      {x, y - 1},
      {x, y + 1}
    ]
    |> Enum.any?(fn neighbor_pos -> neighbor_pos == prospect end)
  end

  defp parse_input(input) do
    grid =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "", trim: true))

    # converts grid into map of {value => [{row_index, column_index}, ...]}
    by_value =
      for {row, row_index} <- Enum.with_index(grid),
          {value, column_index} <- Enum.with_index(row) do
        {value, {row_index, column_index}}
      end
      |> Enum.reduce(%{}, fn {value, {row_index, column_index}}, acc ->
        Map.update(acc, value, [{row_index, column_index}], fn
          nil ->
            [{row_index, column_index}]

          existing ->
            [{row_index, column_index} | existing]
        end)
      end)

    {grid, by_value}
  end
end
