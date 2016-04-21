require "minitest/autorun"
require "./lib/sales_analyst"
require "./lib/sales_engine"

class SalesAnalystTest < Minitest::Test
  attr_reader :se, :sa

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      })
    @sa = SalesAnalyst.new(se)
  end

  def test_it_has_access_to_sales_engine
    assert sa.sales_engine
    assert sa.sales_engine.merchants
    assert sa.sales_engine.merchants.all_merchants
    assert sa.sales_engine.items
    assert sa.sales_engine.items.all_items
  end

  def test_can_find_merchant_by_id
    assert_equal "JUSTEmonsters", se.merchants.find_by_id(12334165).name
  end

  def test_it_gets_all_items_for_merchant
    merchant = se.merchants.find_by_id(12334165)
    assert_kind_of Array, merchant.items
    assert_kind_of Item, merchant.items[0]
  end

  def test_it_gets_merchant_for_item
    item = se.items.find_by_id(263423833)
    assert item.name.include?("Original")
    assert_equal "JUSTEmonsters", item.merchant.name
    # puts item.merchant.inspect
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
