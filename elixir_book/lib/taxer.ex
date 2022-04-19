defmodule Taxer do
  @moduledoc """
  Applies taxes to orders.
  """
  def apply_state_taxes(orders, tax_rates) do
    orders
    |> Enum.map(&add_taxes_to_order(&1, tax_rates))
  end

  def add_taxes_to_order(
        order,
        rates
      ) do
    [ship_to: ship_to, net_amount: net] = Keyword.take(order, [:ship_to, :net_amount])
    rate = Keyword.get(rates, ship_to, 0)
    order ++ [total_amount: calculate_total(net, rate)]
  end

  def calculate_total(net_amount, tax_rate) do
    Float.round(net_amount * (1 + tax_rate), 2)
  end
end
