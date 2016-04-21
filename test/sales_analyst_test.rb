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
    skip
    item = se.items.find_by_id(263423833)
    assert item.name.include?("Original")
    assert_equal "JUSTEmonsters", item.merchant.name
    # puts item.merchant.inspect
    # sa = SalesAnalyst.new
    # sa.average_items_per_merchant()
  end

  def test_it_finds_average_items_per_merchant
    assert_equal 2.88, sa.average_items_per_merchant
  end

  def test_it_finds_avg_item_per_merch_std_deviation
    assert_equal 3.26, sa.average_items_per_merchant_standard_deviation
  end

  def test_it_finds_merchants_with_high_item_count
    assert_kind_of Array, sa.merchants_with_high_item_count
  end

  def test_it_finds_avg_price_per_merchant
    assert_kind_of BigDecimal, sa.average_item_price_for_merchant(12334165)
  end

  def test_it_finds_avg_avg_price_per_merchant
    assert_kind_of BigDecimal, sa.average_average_price_per_merchant
  end

  def test_if_calculates_item_price_std_diviation
    assert_kind_of Numeric, sa.price_standard_deviation
  end

  def test_calculates_average_item_price
    assert_kind_of BigDecimal, sa.average_item_price
    puts sa.average_item_price.to_f

  end

  def test_it_finds_golden_items
    assert_kind_of Array, sa.golden_items
    # sa.golden_items.each { |item| puts item.name }
  end

end
