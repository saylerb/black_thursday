require "./test/test_helper"
require "minitest/autorun"
require "minitest/pride"
require "./lib/sales_analyst"
require "./lib/sales_engine"
require "time"

class MerchantAnalystTest < Minitest::Test

  def setup
    @se = SalesEngine.from_csv({
      :items     => "./data/items.csv",
      :merchants => "./data/merchants.csv",
      :invoices  => "./data/invoices.csv",
      :invoice_items => "./data/invoice_items.csv",
      :transactions => "./data/transactions.csv",
      :customers => "./data/customers.csv"})
    @sa = SalesAnalyst.new(@se)
  end

  def test_it_calculates_total_for_date_
    date = Time.parse("2013-06-18")
    assert_kind_of BigDecimal, @sa.total_revenue_by_date(date)
    assert_equal 2838.84, @sa.total_revenue_by_date(date).to_f
  end

  def test_it_finds_top_20_performing_merchants
    assert_equal 20, @sa.top_revenue_earners.length 
    assert_equal 12334634, @sa.top_revenue_earners.first.id
  end

  def test_finds_most_sold_item_for_merchant
    items = @sa.most_sold_item_for_merchant(12337105)
    assert_kind_of Array, items
    assert_equal 4, items.length
  end

  def test_finds_best_item_for_merchant
    best_item = @sa.best_item_for_merchant(12337105)
    assert_kind_of Item, best_item
  end

  def test_it_can_rank_merchants_by_revenue
    ranked = @sa.merchants_ranked_by_revenue
    assert_kind_of Array, ranked
    assert_kind_of Merchant, ranked.first
    assert_equal 12334634, ranked.first.id
    assert_equal 475, ranked.length
  end

  def test_it_can_find_all_merchants_with_pending_invoices
    merchants = @sa.merchants_with_pending_invoices
    assert_kind_of Array, merchants
    assert_kind_of Merchant, merchants.first
    assert_equal 467, merchants.length
  end

  def test_it_can_find_merchants_with_only_one_item
    merchants = @sa.merchants_with_only_one_item
    assert_kind_of Array, merchants
    assert_kind_of Merchant, merchants.first
    assert_equal 12334112, merchants.first.id

  end

  def test_it_can_find_merchants_with_only_one_item_for_month
    merchants = @sa.merchants_with_only_one_item_registered_in_month("May")
    merchants_ids = merchants.map { |merchant| merchant.id }
    assert_kind_of Array, merchants
    assert_kind_of Merchant, merchants.first
    assert merchants_ids.include?(12334112)
  end
  # 12334112, "2009-05-30"

  def test_calculate_average_invoices_per_merchant
    num = @sa.average_invoices_per_merchant_standard_deviation
    assert_kind_of Numeric, num
  end

  def test_find_top_merchants_by_invoice_count
    merchants = @sa.top_merchants_by_invoice_count
    assert_kind_of Array, merchants
    assert_kind_of Merchant,  merchants.first
    assert_equal 12, merchants.length
  end

  def test_find_bot_merchants_by_invoice_count
    merchants = @sa.bottom_merchants_by_invoice_count
    assert_kind_of Array, merchants
    assert_kind_of Merchant,  merchants.first
    assert_equal 4, merchants.length
  end

end
