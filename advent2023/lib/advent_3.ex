defmodule Advent3 do

  @symbols ["*", "#", "+", "$", "@", "&", "!", "-", "_", "^", "%", "&"]

  @doc """

  ## Examples

      iex> Advent3.solve("467..114..
      ...> ...*......
      ...> ..35..633.
      ...> ......#...
      ...> 617*......
      ...> .....+.58.
      ...> ..592.....
      ...> ......755.
      ...> ...$.*....
      ...> .664.598..")
      4361

      iex> Advent3.solve("467..114..
      ...> ...*......
      ...> ..35..633.
      ...> ......#...
      ...> 617*......
      ...> .....+.58.
      ...> ..592.....
      ...> ......755.
      ...> ...$.*....
      ...> .664.598..", :part2)
      2286

  """
  def solve(input) do
    rows = input
    |> sanitize_rows()
    symbols = rows
    |> identify_symbols()
    numbers = rows
    |> identify_number_ranges()

    numbers
    |> Enum.filter(fn number_tuple -> in_range?(number_tuple, symbols) end)
    |> Enum.map(fn {number, _, _} -> String.to_integer(number) end)
    |> Enum.sum()
  end

  def solve(input, :part2) do
    input
  end

  defp sanitize_rows(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp identify_symbols(rows) do
    rows
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.filter(fn {char, _column} -> Regex.match?(~r/[^a-zA-Z0-9\.\s]/, char) end)
      |> Enum.map(fn {_char, column} -> {column, row_index} end)
    end)
  end

  defp identify_number_ranges(rows) do
    rows
    |> Enum.with_index()
    |> Enum.flat_map(fn {row, row_index} ->
      matches = Regex.scan(~r/\d+/, row, return: :index)
      Enum.map(matches, fn match -> transform_match_to_range(match, row, row_index) end)
    end)
  end

  defp transform_match_to_range(match, row, row_index) do
    [{start_column, length}] = match
    substring = String.slice(row, start_column, length)
    end_column = start_column + length - 1
    {substring, {start_column - 1, row_index - 1}, {end_column + 1, row_index + 1}}
  end

  defp in_range?({_, {start_column, start_row}, {end_column, end_row}}, symbols) do
    symbols
    |> Enum.any?(fn {column, row} ->
      column >= start_column and column <= end_column and
      row >= start_row and row <= end_row
    end)
  end
end