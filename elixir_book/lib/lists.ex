defmodule Lists do
  @moduledoc """
  Module for generating lists
  """

  import Prime, only: [primeify: 3]

  def span(from, to) do
    from..to
      |> Enum.to_list
  end

  def prime_span(to) do
    primeify([], 2, to)
  end
end
