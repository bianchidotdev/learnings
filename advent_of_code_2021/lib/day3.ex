defmodule AdventOfCode2021.Day3 do
  @moduledoc """
  Test
  Example:

    iex> import AdventOfCode2021.Day3; \
      sample_input() |> calculate_energy_consumption()
    198

    # iex> import AdventOfCode2021.Day3; \
    #   sample_input() |> oxygen_rating()
    # 23

    iex> import AdventOfCode2021.Day3; \
      sample_input() |> list_of_bitstrings() |> gamma()
    22

    iex import AdventOfCode2021.Day3; \
      sample_input() |> list_of_bitstrings() |> epsilon()
    9

    iex> import AdventOfCode2021.Day3; \
      sample_input() |> list_of_bitstrings() |> dominant_bit_for_bitstring_list(0)
    1

    iex> import AdventOfCode2021.Day3; left_truncate_bitstring(<<31::5>>, 4)
    <<15::4>>

  """
  alias AdventOfCode2021.InputHandler, as: InputHandler
  require Logger

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
    bitstring_list = input |> list_of_bitstrings()
    gamma(bitstring_list) * epsilon(bitstring_list)
  end

  def gamma(bitstring_list) do
    gamma_bit_list(bitstring_list)
    |> bit_list_to_bitstring()
    |> bitstring_to_decimal()
  end

  def gamma_bit_list(bitstring_list) do
    len = bit_size(List.first(bitstring_list))

    0..(len - 1)
    |> Enum.map(&dominant_bit_for_bitstring_list(bitstring_list, &1))
  end

  def epsilon(bitstring) do
    gamma_bit_list(bitstring)
    |> flip_bit_list()
    |> bit_list_to_bitstring()
    |> bitstring_to_decimal()
  end

  def flip_bit_list(bit_list) do
    for i <- bit_list, do: flip_bit(i), into: []
  end

  def flip_bit(0), do: 1
  def flip_bit(1), do: 0

  def bit_list_to_bitstring(bit_list) do
    for i <- bit_list, do: <<i::1>>, into: <<>>
  end

  def list_of_bitstrings(input) do
    input |> Enum.map(&string_to_bitstring/1)
  end

  def string_to_bitstring(string) do
    String.codepoints(string)
    |> Enum.map(&String.to_integer/1)
    |> bit_list_to_bitstring()
  end

  def extract_bit(el, bits) do
    <<_::size(el), bit::1, _rest::bits>> = bits
    bit
  end

  def dominant_bit_for_bitstring_list(bitstring_list, bit) do
    bit_size = bit_size(List.first(bitstring_list)) - bit
    rem_size = bit_size - 1
    ref = bitstring_to_decimal(<<1::1, 0::size(rem_size)>>)

    num_ones =
      bitstring_list
      |> Enum.map(&left_truncate_bitstring(&1, bit_size))
      |> Enum.map(&bitstring_to_decimal/1)
      |> Enum.map(fn
        v when v >= ref -> 1
        _ -> 0
      end)
      |> Enum.sum()

    case num_ones > length(bitstring_list) / 2 do
      true -> 1
      false -> 0
    end
  end

  def left_truncate_bitstring(bitstring, trunc_size) do
    rem_size = bit_size(bitstring) - trunc_size
    <<_::size(rem_size), n::bits>> = bitstring
    n
  end

  def bitstring_to_decimal(bitstring) do
    size = bit_size(bitstring)
    <<n::size(size)>> = bitstring
    n
  end
end
