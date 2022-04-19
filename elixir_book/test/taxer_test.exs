defmodule TaxerTest do
  use ExUnit.Case
  doctest Taxer

  @tax_rates [NC: 0.075, TX: 0.08]
  @orders [
    [id: 123, ship_to: :NC, net_amount: 100.00],
    [id: 124, ship_to: :OK, net_amount: 35.50],
    [id: 125, ship_to: :TX, net_amount: 24.00],
    [id: 126, ship_to: :TX, net_amount: 44.80],
    [id: 127, ship_to: :NC, net_amount: 25.00],
    [id: 128, ship_to: :MA, net_amount: 10.00],
    [id: 129, ship_to: :CA, net_amount: 102.00],
    [id: 130, ship_to: :NC, net_amount: 40.00],
  ]
  @expected_taxes [
    [total_amount: 107.50],
    [total_amount: 35.50],
    [total_amount: 25.92],
    [total_amount: 48.38],
    [total_amount: 26.88],
    [total_amount: 10.00],
    [total_amount: 102.00],
    [total_amount: 43.00],
  ]
  def expected do
    @orders |>
      Enum.zip_reduce(
        @expected_taxes,
        [],
        fn x, y, acc -> [(x ++ y) | acc] end
      ) |>
      Enum.reverse
  end

  # ch10 ListsAndRecursion-8
  test "add taxes to orders" do
    assert Taxer.apply_state_taxes(@orders, @tax_rates) == expected()
  end

  # ch 11 StringsAndBinaries-7
  test "add taxes to order file" do
    assert OrderReader.read("resources/orders.csv") == @orders
    assert Taxer.apply_state_taxes(@orders, @tax_rates) == expected()
  end
end
