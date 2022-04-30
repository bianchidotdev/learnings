defmodule FizzBuzz do
  @moduledoc """
  Module for generating fizzbuzz lists
  """
  def upto(n) when n > 0 do
    1..n |> Enum.map(&fizzbuzz_case/1)
  end

  def fizzbuzz_case(n) do
    case {rem(n, 3), rem(n, 5)} do
      {0, 0} -> "fizzbuzz"
      {0, _} -> "fizz"
      {_, 0} -> "buzz"
      {_, _} -> n
    end
  end
end
