defmodule PrimeTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Prime

  test "returns empty array when creating a list less than 2" do
    assert Prime.primeify([], 0, 0) == []
  end

  # test "2 is prime"

  # property "even numbers are never prime" do
  #   check all even_num <- map(integer(), fn int -> int * 2 end) do
  #     assert Prime.is_prime?(even_num) == false
  #   end
  # end
end
