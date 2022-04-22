defmodule AdventOfCode2021.Day3 do
  @doc """
  Test
  Example:

    iex> alias AdventOfCode2021.Day3, as: Day3; \
      Day3.sample_input() |> Day3.calculate_energy_consumption
    198

  """
  alias AdventOfCode2021.InputHandler, as: InputHandler

  def sample_input do
    ~w[
        00100
        11110
        10110
        10111
        10101
        01111
        00111
        11100
        10000
        11001
        00010
        01010
      ]
  end

  def input do
    InputHandler.input(3)
  end

  def ex1 do
    input() |> calculate_energy_consumption()
  end

  def ex2 do
    input()
  end

  def calculate_energy_consumption(input) do
    bit_lists = input |> Enum.map(&to_binary_list/1)
    gamma(bit_lists) * epsilon(bit_lists)
  end

  def gamma(input) do
    calculate_bits(input) |>
      Enum.join() |>
      String.to_integer(2)
  end

  def epsilon(input) do
    calculate_bits(input) |>
      Enum.map(&flip_bit/1) |>
      Enum.join() |>
      String.to_integer(2)
  end

  def calculate_bits(input) do
    freqs_by_column(input) |>
      Enum.map(&max_by_bit/1)
  end

  def max_by_bit(%{0 => zeros, 1 => ones}) when ones > zeros, do: 1
  def max_by_bit(%{0 => zeros, 1 => ones}) when ones < zeros, do: 0
  def max_by_bit(%{0 => zeros, 1 => ones}) when ones == zeros do
    raise("No requirements given if equal bits")
  end

  def flip_bit(0), do: 1
  def flip_bit(1), do: 0


  def to_binary_list(string) do
    string |> String.codepoints() |> Enum.map(&String.to_integer/1)
  end

  def transpose(input) do
    Enum.zip(input) |>  Enum.map(&(Tuple.to_list(&1)))
  end

  def freqs_by_column(input) do
    input |>
      transpose() |>
      Enum.map(&Enum.frequencies/1)
  end
end
