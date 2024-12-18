defmodule AdventOfCode.Day17 do
  def part1(input) do
    parse_input(input)
    |> run_program()
    |> Enum.join(",")
  end

  def part2(_args) do
  end

  defp run_program({commands, registers}) do
    run_program(commands, registers, 0, [])
    |> Enum.reverse()
  end

  defp run_program(commands, registers, command_index, output) do
    op_combo = Enum.slice(commands, command_index, 2)

    if length(op_combo) < 2 do
      output
    else
      [op, combo] = op_combo
      combo_value = get_combo_value(combo, registers)

      action =
        case op do
          "0" ->
            {:registers, Map.put(registers, :A, div(registers[:A], 2 ** combo_value))}

          "1" ->
            {:registers, Map.put(registers, :B, Bitwise.bxor(registers[:B], combo_value))}

          "2" ->
            {:registers, Map.put(registers, :B, Integer.mod(combo_value, 8))}

          "3" ->
            case registers[:A] do
              0 -> {}
              _value -> {:jump, combo_value}
            end

          "4" ->
            {:registers, Map.put(registers, :B, Bitwise.bxor(registers[:B], registers[:C]))}

          "5" ->
            {:output, ["#{Integer.mod(combo_value, 8)}" | output]}

          "6" ->
            {:registers, Map.put(registers, :B, div(registers[:A], 2 ** combo_value))}

          "7" ->
            {:registers, Map.put(registers, :C, div(registers[:A], 2 ** combo_value))}
        end

      case action do
        {:jump, value} ->
          run_program(commands, registers, value, output)

        {:registers, new_registers} ->
          run_program(commands, new_registers, command_index + 2, output)

        {:output, new_output} ->
          run_program(commands, registers, command_index + 2, new_output)

        _ ->
          run_program(commands, registers, command_index + 2, output)
      end
    end
  end

  defp get_combo_value(combo, registers) do
    case combo do
      "0" ->
        0

      "1" ->
        1

      "2" ->
        2

      "3" ->
        3

      "4" ->
        registers[:A]

      "5" ->
        registers[:B]

      "6" ->
        registers[:C]
    end
  end

  defp parse_input(input) do
    [register_input, command_input] =
      input
      |> String.split("\n\n", trim: true)

    registers =
      register_input
      |> String.split("\n", trim: true)
      |> Enum.reduce(%{}, fn line, acc ->
        regex = ~r/Register (?<char>\w): (?<value>\d+)/
        captures = Regex.named_captures(regex, line)
        Map.put(acc, String.to_atom(captures["char"]), String.to_integer(captures["value"]))
      end)

    commands =
      command_input
      |> String.trim()
      |> String.replace_prefix("Program: ", "")
      |> String.split(",", trim: true)

    {commands, registers}
  end
end
