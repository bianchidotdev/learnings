defmodule AdventOfCode.Day07 do
  def part1(input) do
    parsed = parse_input(input)

    Enum.map(parsed, fn {target, factors} ->
      {target, match?(target, factors, [&Kernel.+/2, &Kernel.*/2])}
    end)
    |> Enum.filter(fn {_target, valid?} -> valid? end)
    |> Enum.map(fn {target, _valid?} -> target end)
    |> Enum.sum()
  end

  def part2(input) do
    parse_input(input)
    |> Enum.map(fn {target, factors} ->
      {target, match?(target, factors, [&Kernel.+/2, &Kernel.*/2, &concat/2])}
    end)
    |> Enum.filter(fn {_target, valid?} -> valid? end)
    |> Enum.map(fn {target, _valid?} -> target end)
    |> Enum.sum()
  end

  defp match?(target, [num], _operators), do: target == num

  defp match?(target, [n1, n2 | rest], operators) do
    Enum.any?(operators, fn operator -> match?(target, [operator.(n1, n2) | rest], operators) end)
  end

  defp concat(n1, n2), do: String.to_integer("#{n1}#{n2}")

  defp parse_input(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, ":", trim: true))
    |> Enum.map(fn [target, factors] ->
      {String.to_integer(target),
       Enum.map(String.split(factors, " ", trim: true), &String.to_integer/1)}
    end)
  end
end
