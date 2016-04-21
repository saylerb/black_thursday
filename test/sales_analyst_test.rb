require "minitest/autorun"
require "./lib/sales_analyst"
require "./lib/sales_engine"

class SalesAnalystTest < Minitest::Test

  def test_it_has_access_to_sales_engine
    se = SalesEngine.from_csv({
  :items     => "./data/items.csv",
  :merchants => "./data/merchants.csv",
})
  end

  def test_if_merchant_can_access_its_items
    skip
#     se = SalesEngine.from_csv({
#   :items     => "./data/items.csv",
#   :merchants => "./data/merchants.csv",
# })
  #  assert se
# merchant = se.merchants.find_by_id(10)
# merchant.items
  end
  def test_it_finds_the_average_items_per_merchant
    skip
    # sa = SalesAnalyst.new
    # sa.average_items_per_merchant()
  end

  def test_it_finds_avg_item_per_merch_std_deviation
    skip
  end

  def test_it_finds_merchants_with_high_item_count
    skip
  end

  def test_it_finds_avg_price_per_merchant
    skip
  end

  def test_it_finds_golden_items
    skip
  end



end
