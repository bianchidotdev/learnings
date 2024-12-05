defmodule AdventOfCode.Day05 do
  def part1(input) do
    {rules, updates} = parse_input(input)

    updates
    |> Enum.filter(&correct_order?(&1, rules))
    |> Enum.map(&get_middle_page/1)
    |> Enum.map(&String.to_integer/1)
    |> Enum.sum()
  end

  def part2(input) do
    {rules, updates} = parse_input(input)

    {_correct_updates, incorrect_updates} =
      updates
      |> Enum.split_with(&correct_order?(&1, rules))

    incorrect_updates
  end

  defp get_middle_page(update) do
    Enum.at(update, div(Enum.count(update), 2))
  end

  defp correct_order?(update, rules) do
    update
    |> Enum.with_index()
    |> Enum.all?(fn {page, index} ->
      previous_pages = Enum.slice(update, 0..index)

      Enum.all?(previous_pages, fn prev ->
        case rules[page] do
          nil -> true
          array -> !Enum.member?(array, prev)
        end
      end)
    end)
  end

  defp parse_input(input) do
    [rules_string, updates_string] =
      input
      |> String.split("\n\n", trim: true)

    rules =
      rules_string
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, "|"))
      |> Enum.map(fn [a, b] -> {a, b} end)
      |> Enum.reduce(%{}, fn {before, afterr}, acc ->
        {_, acc} =
          Map.get_and_update(acc, before, fn
            nil -> {nil, [afterr]}
            after_array -> {after_array, [afterr | after_array]}
          end)

        acc
      end)

    updates =
      updates_string
      |> String.split("\n", trim: true)
      |> Enum.map(&String.split(&1, ","))

    {rules, updates}
  end
end
