require "minitest/autorun"
require "minitest/pride"
require "./lib/sales_engine"

class SalesEngineTest < Minitest::Test

  def test_it_loads_merchants_csv
    se = SalesEngine.from_csv({:items     => "./data/items.csv",
                               :merchants => "./data/merchants.csv",
                               :invoices  => "./data/invoices.csv"})
    mr = se.merchants
    merchant = mr.find_by_name("CJsDecor")
    assert_kind_of Merchant, merchant
  end

  def test_it_loads_items_csv
    se = SalesEngine.from_csv({:items     => "./data/items.csv",
                               :merchants => "./data/merchants.csv",
                               :invoices  => "./data/invoices.csv"})
    ir = se.items
    item = ir.find_by_name("Woodsy Sh!tz Spr!tz")
    assert_kind_of Item, item
  end

  def test_it_loads_invoices_csv
    se = SalesEngine.from_csv({:items     => "./data/items.csv",
                               :merchants => "./data/merchants.csv",
                               :invoices  => "./data/invoices.csv"})
    assert se.invoices
  end

end
