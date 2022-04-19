defmodule OrderReader do
  @moduledoc """
  Parses orders from a csv file
  """

  def read(file) do
    {:ok, body} = File.read(file)
    body |>
      String.split("\n") |>
      Enum.map(&line_to_order/1)
  end

  defp line_to_order(line) do
    [id, ship_to, net] = String.split(line, ",")
    [
      id: String.to_integer(id),
      ship_to: String.to_atom(String.replace(ship_to, ":", "")),
      net_amount: String.to_float(net)
    ]
  end
end
