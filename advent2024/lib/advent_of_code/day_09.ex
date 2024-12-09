defmodule AdventOfCode.Day09 do
  def part1(input) do
    parse_input(input)
    |> expand()
    |> List.flatten()
    |> compact()
    |> Enum.reject(&(&1 == "."))
    |> Enum.with_index()
    |> Enum.map(fn {num, index} -> String.to_integer(num) * index end)
    |> Enum.sum()
  end

  def part2(input) do
    parse_input(input)
    |> get_blocks_with_index()
    |> compact_whole_blocks()
    |> compute_checksum()
  end

  defp compute_checksum(blocks) do
    blocks
    |> Enum.flat_map(fn {char, size, index} ->
      Enum.map(0..(size - 1), fn count -> String.to_integer(char) * (index + count) end)
    end)
    |> Enum.sum()
  end

  defp compact_whole_blocks(blocks) do
    {number_blocks, dot_blocks} =
      blocks
      |> Enum.split_with(fn {char, _, _} -> char != "." end)

    # each block is {{char, block_size}, block_index}
    # if a number block can fit in a dot block at an earlier index, we compact it
    # we try each number block once
    number_blocks
    |> Enum.reverse()
    |> Enum.reduce({[], dot_blocks}, fn
      number_block, {num_acc, dot_blocks} ->
        {new_number_block, dot_blocks} =
          Enum.reduce(dot_blocks, {number_block, []}, fn
            dot_block, {number_block, dot_acc} ->
              {num_char, num_size, num_index} = number_block
              {dot_char, dot_size, dot_index} = dot_block

              if num_size <= dot_size && num_index > dot_index do
                {{num_char, num_size, dot_index},
                 [{dot_char, dot_size - num_size, dot_index + num_size} | dot_acc]}
              else
                {number_block, [dot_block | dot_acc]}
              end
          end)

        dot_blocks = Enum.reverse(dot_blocks)

        {[new_number_block | num_acc], dot_blocks}
    end)
    |> elem(0)
    |> Enum.reverse()
  end

  defp compact(list) do
    {numbers, dots} = Enum.split_with(list, &(&1 != "."))
    number_pool = Enum.reverse(numbers)

    {compacted, _} =
      list
      |> Enum.reduce({[], number_pool}, fn
        ".", {acc, [new | rest]} -> {[new | acc], rest}
        el, {acc, pool} -> {[el | acc], pool}
      end)

    compacted_numbers =
      compacted
      |> Enum.reverse()
      |> Enum.take(Enum.count(numbers))

    compacted_numbers ++ dots
  end

  defp expand(files) do
    {list, _count} =
      files
      |> Enum.chunk_every(2)
      |> Enum.reduce({[], 0}, fn
        [a, b], {acc, count} ->
          {[expand_block(b, "."), expand_block(a, "#{count}") | acc], count + 1}

        [a], {acc, count} ->
          {[expand_block(a, "#{count}") | acc], count + 1}
      end)

    list
    |> Enum.reverse()
  end

  defp expand_block(0, _), do: []

  defp expand_block(num, char) do
    0..(num - 1)
    |> Enum.map(fn _ -> char end)
  end

  defp get_blocks_with_index(files) do
    {list, _count, _index} =
      files
      |> Enum.chunk_every(2)
      |> Enum.reduce({[], 0, 0}, fn
        [a, b], {acc, count, index} ->
          {[{".", b, index + a}, {"#{count}", a, index} | acc], count + 1, index + a + b}

        [a], {acc, count, index} ->
          {[{"#{count}", a, index} | acc], count + 1, index + a}
      end)

    list
    # eliminate null . blocks
    |> Enum.filter(fn {_, count, _} -> count != 0 end)
    |> Enum.reverse()
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
