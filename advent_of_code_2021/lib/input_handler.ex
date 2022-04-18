defmodule AdventOfCode2021.InputHandler do
  def input(day) do
    {:ok, body} = File.read("resources/day#{day}_input.txt")
    body |>
      String.trim |>
      String.split("\n")
  end
end
