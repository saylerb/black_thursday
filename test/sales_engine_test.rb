require "minitest/autorun"
require "minitest/pride"
require "./lib/sales_engine"

class SalesEngineTest < Minitest::Test

  attr_reader :se

  def setup
    @se = SalesEngine.from_csv({:items     => "./data/items.csv",
                               :merchants => "./data/merchants.csv",
                               :invoices  => "./data/invoices.csv",
                               :invoice_items => "./data/invoice_items.csv",
                               :transactions => "./data/transactions.csv",
                               :customers => "./data/customers.csv"})
  end

  def test_it_loads_each_repo
    assert se.merchants
    assert se.items
    assert_kind_of Item, se.items.find_by_name("Woodsy Sh!tz Spr!tz")
    assert se.invoices
    assert se.invoice_items
    assert se.transactions
    assert se.customers
  end

  def test_it_can_find_items_for_invoice
    invoice = se.invoices.find_by_id(20)
    # require "pry"; binding.pry
    invoice.items.inspect
  end

end
