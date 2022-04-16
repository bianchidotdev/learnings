defmodule ListsTest do
  use ExUnit.Case
  doctest ElixirBook

  # ch7 ListsAndRecursion-4
  test "span returns list from a to b" do
    assert Lists.span(3, 5) == [3, 4, 5]
  end

  # ch10 ListsAndRecursion-7
  test "prime list from 2 to n" do
    assert Lists.prime_span(15) == [2, 3, 5, 7, 11, 13]
    assert Lists.prime_span(25) == [2, 3, 5, 7, 11, 13, 17, 19, 23]
    assert length(Lists.prime_span(10000)) == 1229
  end
end
