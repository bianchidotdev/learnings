defmodule FizzBuzzTest do
  use ExUnit.Case
  doctest FizzBuzz

  # ch12 ControlFlow-1
  test "returns fizzbuzz results up 15" do
    assert FizzBuzz.upto(15) == [
             1,
             2,
             "fizz",
             4,
             "buzz",
             "fizz",
             7,
             8,
             "fizz",
             "buzz",
             11,
             "fizz",
             13,
             14,
             "fizzbuzz"
           ]
  end
end
