defmodule Advent1 do
  @moduledoc """
  Documentation for `Advent1`.
  """

  @mapping %{
    ~r/1/ => "1",
    ~r/2/ => "2",
    ~r/3/ => "3",
    ~r/4/ => "4",
    ~r/5/ => "5",
    ~r/6/ => "6",
    ~r/7/ => "7",
    ~r/8/ => "8",
    ~r/9/ => "9",
    ~r/one/ => "1",
    ~r/two/ => "2",
    ~r/three/ => "3",
    ~r/four/ => "4",
    ~r/five/ => "5",
    ~r/six/ => "6",
    ~r/seven/ => "7",
    ~r/eight/ => "8",
    ~r/nine/ => "9"
  } 

  @doc """

  ## Examples

      iex> Advent1.solve("1abc2
      ...> pqr3stu8vwx
      ...> a1b2c3d4e5f
      ...> treb7uchet")
      142

      iex> Advent1.solve("two1nine
      ...> eightwothree
      ...> abcone2threexyz
      ...> xtwone3four
      ...> 4nineeightseven2
      ...> zoneight234
      ...> 7pqrstsixteen")
      281

  """
  def solve(input) do
    # this should take an option so we can switch between part 1 and part 2
    input
    |> String.split("\n")
    |> Enum.filter(&(String.trim(&1) != ""))
    |> Enum.map(&normalize/1)
    |> Enum.sum()
  end

  # extracts all the numbers from the string combines the first and last
  def normalize(string) do
    string
    |> parse_numbers()
    |> concat_first_and_last()
    |> String.to_integer()
  end

  def parse_numbers(string) do
    Enum.flat_map(@mapping, fn {regex, num} ->
      matches = Regex.scan(regex, string, return: :index)
      case matches do
        [] -> []
        # scan returns a double array, so we need to just pull the first of the pattern match
        matches -> Enum.map(matches, fn [{start, _}] -> {start, num} end)
      end
    end)
  end

  def concat_first_and_last(matches) do
    sorted_matches = Enum.sort(matches, fn {a, _}, {b, _} -> a < b end)
    {_, first} = List.first(sorted_matches)
    {_, last} = List.last(sorted_matches)
    first <> last
  end
end
