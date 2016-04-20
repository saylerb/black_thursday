require "minitest/autorun"
require "./lib/sales_analyst"

class SalesAnalystTest < Minitest::Test

  def test_it_finds_the_average_items_per_merchant
    sa = SalesAnalyst.new
    sa.average_items_per_merchant()
  end

  def test_it_finds_avg_item_per_merch_std_deviation
  end

  def test_it_finds_merchants_with_high_item_count
  end

  def test_it_finds_avg_price_per_merchant
  end

  def test_it_finds_golden_items
  end



end
