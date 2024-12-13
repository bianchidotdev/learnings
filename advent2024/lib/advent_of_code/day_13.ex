defmodule AdventOfCode.Day13.Machine do
  defstruct button_a: nil, button_b: nil, prize: nil
end

defmodule AdventOfCode.Day13 do
  @a_cost 3
  @b_cost 1
  alias AdventOfCode.Day13.Machine

  def part1(input) do
    parse_input(input)
    |> Enum.map(&solve2/1)
    |> Enum.filter(& &1)
    |> Enum.map(fn {a_count, b_count} ->
      a_count * @a_cost + b_count * @b_cost
    end)
    |> Enum.sum()
  end

  def part2(input) do
    part2_offset = 10_000_000_000_000

    parse_input(input)
    |> Enum.map(fn machine ->
      Map.update!(machine, :prize, fn {x, y} -> {x + part2_offset, y + part2_offset} end)
    end)
    |> Enum.map(&solve2/1)
    |> Enum.filter(& &1)
    |> Enum.map(fn {a_count, b_count} ->
      a_count * @a_cost + b_count * @b_cost
    end)
    |> Enum.sum()
  end

  defp solve2(machine) do
    {x, y} = machine.prize
    {a_x, a_y} = machine.button_a
    {b_x, b_y} = machine.button_b

    determinent = a_x * b_y - a_y * b_x

    x_count = (x * b_y - b_x * y) / determinent
    y_count = (y * a_x - a_y * x) / determinent

    if x_count == trunc(x_count) and y_count == trunc(y_count) do
      {trunc(x_count), trunc(y_count)}
    else
      false
    end
  end

  # defp solve(machine) do
  #   {x, y} = machine.prize
  #   {a_x, a_y} = machine.button_a
  #   {b_x, b_y} = machine.button_b

  #   for a_count <- 0..100,
  #       b_count <- 0..100,
  #       a_count * a_x + b_count * b_x == x and
  #         a_count * a_y + b_count * b_y == y do
  #     {a_count, b_count}
  #   end
  #   |> Enum.map(fn {a_count, b_count} -> a_count * @a_cost + b_count * @b_cost end)
  # end

  defp parse_input(input) do
    input
    |> String.split("\n\n", trim: true)
    |> Enum.map(&parse_machine/1)
  end

  defp parse_machine(input) do
    [a_string, b_string, prize_string] =
      input
      |> String.split("\n", trim: true)

    button_regex = ~r/Button \w: X\+(?<x>\d+), Y\+(?<y>\d+)/
    a_match = Regex.named_captures(button_regex, a_string)
    b_match = Regex.named_captures(button_regex, b_string)
    prize_match = Regex.named_captures(~r/Prize: X=(?<x>\d+), Y=(?<y>\d+)/, prize_string)

    %Machine{
      button_a: {String.to_integer(a_match["x"]), String.to_integer(a_match["y"])},
      button_b: {String.to_integer(b_match["x"]), String.to_integer(b_match["y"])},
      prize: {String.to_integer(prize_match["x"]), String.to_integer(prize_match["y"])}
    }
  end
end
