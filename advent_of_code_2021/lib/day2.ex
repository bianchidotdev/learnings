defmodule AdventOfCode2021.Day2 do
  alias AdventOfCode2021.InputHandler, as: InputHandler

  def input do
    InputHandler.input(2)
  end

  def ex1 do
    %{depth: depth, forward: forward} =
      input()
      |> Enum.map(&string_to_position_change/1)
      |> aggregate_moves_naive(%{forward: 0, depth: 0})

    depth * forward
  end

  def ex2 do
    %{depth: depth, forward: forward} =
      input()
      |> Enum.map(&string_to_position_change/1)
      |> aggregate_moves_with_aim(%{forward: 0, depth: 0, aim: 0})

    depth * forward
  end

  def string_to_position_change(string) do
    %{"dir" => dir, "mag" => mag} = Regex.named_captures(~r/(?<dir>\w+)\s(?<mag>\d+)/, string)
    %{direction: dir, magnitude: String.to_integer(mag)}
  end

  def aggregate_moves_naive([head | tail], %{forward: forward, depth: depth}) do
    {forward_delta, depth_delta} = position_change_to_tuple_naive(head)
    aggregate_moves_naive(tail, %{forward: forward + forward_delta, depth: depth + depth_delta})
  end

  def aggregate_moves_naive([], position), do: position

  def position_change_to_tuple_naive(%{direction: "forward", magnitude: mag}), do: {mag, 0}
  def position_change_to_tuple_naive(%{direction: "up", magnitude: mag}), do: {0, -mag}
  def position_change_to_tuple_naive(%{direction: "down", magnitude: mag}), do: {0, mag}

  def aggregate_moves_with_aim([head | tail], %{forward: forward, depth: depth, aim: aim}) do
    {forward_delta, depth_delta, aim_delta} =
      position_change_to_tuple_with_aim(Map.merge(head, %{aim: aim}))

    aggregate_moves_with_aim(tail, %{
      forward: forward + forward_delta,
      depth: depth + depth_delta,
      aim: aim + aim_delta
    })
  end

  def aggregate_moves_with_aim([], position), do: position

  def position_change_to_tuple_with_aim(%{direction: "forward", magnitude: mag, aim: aim}),
    do: {mag, mag * aim, 0}

  def position_change_to_tuple_with_aim(%{direction: "up", magnitude: mag}), do: {0, 0, -mag}
  def position_change_to_tuple_with_aim(%{direction: "down", magnitude: mag}), do: {0, 0, mag}
end
