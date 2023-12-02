defmodule Advent2 do
  @mapping %{
    "red" => 12,
    "green" => 13,
    "blue" => 14
  }

  @doc """

  ## Examples

      iex> Advent2.solve("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
      ...> Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
      ...> Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
      ...> Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
      ...> Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green")
      8

      iex> Advent2.solve("Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
      ...> Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
      ...> Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
      ...> Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
      ...> Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green", :part2)
      2286

  """
  def solve(input) do
    raw_games = sanitize_games(input)

    raw_games
    |> Enum.map(&parse_game/1)
    |> Enum.filter(&valid_game?/1)
    |> Enum.map(&Map.get(&1, "game_number"))
    |> Enum.sum()
  end

  def solve(input, :part2) do
    raw_games = sanitize_games(input)

    raw_games
    |> Enum.map(&parse_game/1)
    |> Enum.map(fn map ->
      Map.take(map, ["red", "green", "blue"]) |> Map.values() |> Enum.reduce(1, &*/2)
    end)
    |> Enum.sum()
  end

  defp sanitize_games(input) do
    input
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reject(&(&1 == ""))
  end

  defp parse_game(game) do
    ["Game " <> game_str, round_input] = String.split(game, ": ")
    {game_number, _} = Integer.parse(game_str)

    round_input
    |> String.split(";")
    |> Enum.map(&parse_round/1)
    |> calculate_maxes()
    |> Map.merge(%{"game_number" => game_number})
  end

  defp calculate_maxes(rounds) do
    # jank
    Enum.reduce(rounds, %{}, fn map, acc ->
      Enum.reduce(map, acc, fn {key, value}, acc ->
        Map.update(acc, key, value, &Kernel.max(&1, value))
      end)
    end)
  end

  defp valid_game?(game) do
    Enum.all?(game, fn {color, num} -> num <= @mapping[color] end)
  end

  defp parse_round(round) do
    round
    |> String.split(",")
    |> Enum.map(&parse_roll/1)
    |> Enum.reduce(%{}, &Map.merge/2)
  end

  defp parse_roll(roll) do
    trimmed =
      roll
      |> String.trim()

    [numStr, color] = String.split(trimmed, " ")
    {num, _} = Integer.parse(numStr)
    %{color => num}
  end
end
