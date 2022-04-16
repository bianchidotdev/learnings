defmodule Prime do
  def primeify(_, current, _) when current < 2 do
    []
  end

  def primeify(acc, current, final) when final <= current do
    acc
  end

  def primeify(_, 2, final) do
    primeify([2], 3, final)
  end

  def primeify(acc, current, final) do
    acc = if is_prime?(current, acc) do
      acc ++ [current]
    else
      acc
    end
    primeify(acc, current + 2, final)
  end

  defp is_prime?(2, _) do
    true
  end

  defp is_prime?(n, _) when rem(n, 2) == 0 do
    false
  end

  defp is_prime?(n, prime_list) do
    !Enum.any?(prime_list, fn x -> rem(n, x) == 0 end)
  end
end
